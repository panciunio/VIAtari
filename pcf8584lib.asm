; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
; MA 02110-1301, USA.
; 
;based on:
;       CS/A65 SCSI interface - http://www.6502.org/users/andre/csa/scsi/index.html
;       Daniel Tufvesson Blog - http://www.waveguide.se/?article=buffered-i2c-interface          
;
;
; 
; name: pcf8584.asm
;
; This is program which is demonstrating how to use PCF 8584 with Atari parallel bus.
; Available functions:
;  pcf_init 
;           no needs arguments, Just jusing only to set the PCF8584.
;           If you need to change transmit parameters, please modify function
;  i2c_send:
;           first byte in i2cbuf is I2C slave address
;           Y  -  length of data to send
;           A/X -  lo/hi address of message
;  i2c_recv
;           receive a message from a device
;           a/x = lo/hi address of message.
;           first byte contains the slave address
;           slave address is not overwritten,
;           received message is stored at ptr+1
;           y = len of message (slave address included)
;
;  Don't forger to set base address for PCF8584 in 'PCF8584.inc' file!


;Messages/ERRORS:
I2C_OK      equ   0
I2C_NODEV   equ   1
I2C_ABORTSD equ   2
I2C_ABORTRD equ   3

         ;Load PCF8584 registers description
         ICL "PCF8584.inc"
         
;variables
ptr      equ   $a0
BUFLEN   equ   10

;PCF library
         
pcf_init lda   #S1_PIN                 ;Set PIN bit in S1 ($80)
         sta   P8584+P8584_S1
         lda   #$55                    ;OWN ADDRESS ($55)
         sta   P8584+P8584_SX
         lda   #(S1_PIN+S1_ES1)        ;PIN=1,ES1=1   CLOCK REGISTER SETTING ($a0)
         sta   P8584+P8584_S1
         lda   #$00                    ;S21=0,S22=0, 3MHz, 90kHz
         sta   P8584+P8584_SX
         lda   #(S1_PIN+S1_ESO+S1_ACK) ;PIN + ES0 + ACK
         sta   P8584+P8584_S1
         
         jsr   i2cbusy
         
         rts
 
i2cbusy  lda   P8584+P8584_S1
         and   #S1_BB
         beq   i2cbusy
         rts


;i2c_send:
;           first byte in i2cbuf is I2C slave address
;           Y  -  length of data to send
;           A/X -  lo/hi address of message

i2c_send sta   ptr
         stx   ptr+1
         sty   len
         
         lda   #$00        ;reset position
         sta   pos
         
         jsr   i2cbusy
         
         ldy   pos
         lda   (ptr),y
         asl
         and   #%11111110
         sta   P8584+P8584_SX       ;set slave address
         inc   pos
         
         lda   #(S1_PIN+S1_ESO+S1_STA+S1_ACK)
         sta   P8584+P8584_S1

i2cwloop lda   P8584+P8584_S1
         bmi   i2cwloop                ;check that data sent, (PIN set)  
         and   #S1_LRB                 ;last received  bit?
         bne   i2c_wend
         ldy   pos
         cpy   len
         beq   i2c_wend
         lda   (ptr),y
         iny
         sty   pos
         sta   P8584+P8584_SX ; send next byte
         jmp   i2cwloop
         

i2c_wend lda   #(S1_PIN+S1_ESO+S1_STO+S1_ACK)   ; set STOP operation on I2C
         sta   P8584+P8584_S1
         
         lda   pos
         cmp   len
         bne   i2c_werr
         clc   ;no error
         rts
         
i2c_werr lda #I2C_ABORTSD          ;set 2 if write error
         sec
         rts

;i2c_recv
;           receive a message from a device
;           a/x = lo/hi address of message.
;           first byte contains the slave address
;           slave address is not overwritten,
;           received message is stored at pointer+1
;           y = len of message (incl slave address)

i2c_recv sta   ptr
         stx   ptr+1
         dey
         
         sty   len      ;save length of buffer to read = # of bytes
         lda   #$00
         sta   pos      ;reset position ptr
         
         ldy   pos          
         lda   (ptr),y
         asl
         ora   #%00000001        ;set read bit
         sta   P8584+P8584_SX    ;slave address

         jsr i2cbusy

         lda   #(S1_PIN+S1_ESO+S1_STA+S1_ACK)
         sta   P8584+P8584_S1

i2crloop lda   P8584+P8584_S1 ; get status
         bmi   i2crloop
         
         and   #S1_LRB                 ;last received  bit?
         bne   i2c_rerr       ;error?
         
         ldy   pos
         iny
         cpy   len
         beq   i2clastb
         
         dey
         
         lda P8584+P8584_SX
         sta (ptr),y
         iny
         sty pos
         
         jmp i2crloop
          
i2clastb dey
         lda   #(S1_ESO)      ;ESO + \ACK
         sta   P8584+P8584_S1
         
         lda   P8584+P8584_SX
         sta   (ptr),y
         iny
         
i2crlast lda   P8584+P8584_S1    ;last byte loop
         bmi   i2crlast

         lda   #(S1_PIN+S1_ESO+S1_STO+S1_ACK)      ;PIN+ESO+STO+ACK = #$C3
         sta   P8584+P8584_S1

         lda   P8584+P8584_SX      ; final byte
         sta   (ptr),y
         clc
         rts

i2c_rerr lda   #(S1_PIN+S1_ESO+S1_STO+S1_ACK)      ;PIN+ESO+STO+ACK = #$C3
         sta   P8584+P8584_S1
         lda   #I2C_ABORTRD  ;read error - return: 3
         sec
         rts    
         

len      dta   $00
ctr      dta   $00
pos      dta   $00
err      dta   $00

i2cbuf   equ  *
.array TAB [BUFLEN] .byte = $ff
.enda
