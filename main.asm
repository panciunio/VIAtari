;  main.asm    
;  
;  Copyright 2018 pancio <pancio@pancio.net>
;  
;  This program is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2 of the License, or
;  (at your option) any later version.
;  
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;  
;  You should have received a copy of the GNU General Public License
;  along with this program; if not, write to the Free Software
;  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
;  MA 02110-1301, USA.

keycode equ $02fc
random  equ $d20a

; known subroutines (S1D15705.asm):
;
;lcd_init:
;   don't need any args
;
;lcd_clear:
;   don't need any args
;
;lcd_pfill:
;   A - pattern to fill display memory
;
;lcd_write_com:
;   A - command to write to LCD
;
;lcd_write_data
;   A - data to send to display memory

; waitkbs:  
;   wait for key
;       A - defined key code
;


;variables on 0 page        
        org $80
        
adr     .ds 2
x       .ds 1
y       .ds 1
a       .ds 1       


        org   $6000
         
;main program         
        
         
start   jsr     via_init            ; set VIA ports
        jsr     lcd_init            ; display initialization
        jsr     lcd_clear
       
        lda     #$ff               ; write pattern to LCD memory
        sta     pattern
        jsr     lcd_pfill
        
        lda     #$21
        ;jsr     waitkbs

 ;test lcd 
                
        ldx     #$00
charl0  lda     font5x8,x                                                   
        eor     #$ff
        sta     lcd_page0,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)      
        bne     charl0
        
        jsr     frm2lcd
         
        lda     #$21
        ;jsr     waitkbs     
 
        
        ldx     #$00
charl1  lda     $e000,x
        sta     lcd_page1,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)      
        bne     charl1
        
        jsr     frm2lcd
        
        lda     #$21
        ;jsr     waitkbs

        
        ldx     #$00                ; get data from Atari chars generator (ROM)
charl2  lda     $e100,x
        sta     lcd_page2,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)     
        bne     charl2
        
        jsr     frm2lcd
        
        lda     #$21
        ;jsr     waitkbs


        
        ldx     #$00
charl3  lda     $e200,x
        sta     lcd_page3,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)    
        bne     charl3    
        
        jsr     frm2lcd
       
        lda     #$21
        ;jsr     waitkbs             


        
        ldx     #$00
charl4  lda     $e300,x
        sta     lcd_page4,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)     
        bne     charl4 

        jsr     frm2lcd

        lda     #$21
        ;jsr     waitkbs     
        

        
        ldx     #$00
charl5  lda     font8x8,x
        eor     #$ff
        sta     lcd_page5,x
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     charl5 
        
        jsr     frm2lcd
        
        lda     #$21
        ;jsr     waitkbs 



        
mloop:
        ldx     #$00
ml0     lda     random
        adc     #$aa
        sta     lcd_page7,x
        and     random
        sta     lcd_page6,x
        and     random
        sta     lcd_page5,x
        and     random
        sta     lcd_page4,x
        and     random
        sta     lcd_page3,x
        and     random
        sta     lcd_page2,x
        and     random
        sta     lcd_page1,x
        and     random
        sta     lcd_page0,x
        inx
        cpx     #LCD_MAX_COLLS +1 
        bne     ml0
        
        jsr     frm2lcd
        
        lda     keycode
        cmp     #$21
        beq     next
            
        jmp     mloop
        
next:
        jsr frmclear
        
 
        lda #$00
        tax
        tay
        
ploop   sty x
        stx y
        sta a
        
        sec
        jsr plot

        
        lda a
        ldx y
        ldy x
        
        iny
        cpy #$a2
        bne ploop

        jsr frm2lcd

        ldy #$00
        
        inx
        cpx #$40
        bne ploop

        ldx #$00
        ldy #$00

ploop2  txs
        tya
        pha
        
        clc
        jsr plot

        
        pla
        tay
        tsx
        
        iny
        cpy #$a2
        bne ploop2

        jsr frm2lcd

        ldy #$00
        
        inx
        cpx #$40
        bne ploop2 
        


_plop3  lda #$00
        tax
        tay

ploop3  sty x
        stx y
        sta a
        
        lda random
        rol
        ;sec
        jsr plot

        
        lda a
        ldx y
        ldy x
        
        iny
        cpy #$a2
        bne ploop3

        ;jsr frm2lcd

        ldy #$00
        
        inx
        cpx #$40
        bne ploop3
        
        jsr frm2lcd
        

        ldx #$00
        ldy #$00

ploop4  txs
        tya
        pha

        lda random
        rol        
        ;clc
        jsr plot

        
        pla
        tay
        tsx
        
        iny
        cpy #$a2
        bne ploop4

        ;jsr frm2lcd

        ldy #$00
        
        inx
        cpx #$40
        bne ploop4 
        
        jsr frm2lcd
        
        lda  keycode
        cmp #$0c
        bne _plop3
         
               
        
         
stop:   
        jsr frmclear
        jsr frm2lcd
        brk



;subroutines
waitkbs:
        pha
              
        lda     #$ff
        sta     keycode
        
        pla
        
kbloop  cmp     keycode
        bne     kbloop
        
        lda     #$ff
        sta     keycode
        
        rts

        ICL "VIA6522.asm"
        ICL "S1D15705.asm"
 
