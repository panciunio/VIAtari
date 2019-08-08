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
;




; waitkbs:  
;   wait for key
;       A - defined key code
;


         ORG   $6000
         
;main program         
        
         
start   jsr     via_init            ; set VIA ports
        jsr     lcd_init            ; display initialization
        jsr     lcd_clear
       
        lda     #$ff               ; write pattern to LCD memory
        sta     pattern
        jsr     lcd_pfill
        lda     #$21
        jsr     waitkbs

 ;test lcd 
    
        lda     #(S1D_SETPAGE0)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L +3)
        jsr     lcd_write_cmd

                
        ldx     #$00
charl0  lda     font5x8,x                                                   
        eor     #$ff
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLLS - 2)      
        bne     charl0 
        lda     #$21
        jsr     waitkbs     
 
        lda     #(S1D_SETPAGE1)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L +3)
        jsr     lcd_write_cmd
        
        ldx     #$00
charl1  lda     $e200,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLLS - 2)      
        bne     charl1
        lda     #$21
        jsr     waitkbs
        
        lda     #(S1D_SETPAGE2)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L +2)
        jsr     lcd_write_cmd
        
        ldx     #$00                ; get data from Atari chars generator (ROM)
charl2  lda     $e100,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLLS - 2)     
        bne     charl2
        lda     #$21
        jsr     waitkbs
        
        lda     #(S1D_SETPAGE3)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        
        ldx     #$00
charl3  lda     $e100,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLLS - 2)    
        bne     charl3 
        lda     #$21
        jsr     waitkbs             

        lda     #(S1D_SETPAGE4)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        
        ldx     #$00
charl4  lda     $e100,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLLS - 2)     
        bne     charl4 
        lda     #$21
        jsr     waitkbs     
        
        lda     #(S1D_SETPAGE5)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        
        ldx     #$00
charl5  lda     font8x8,x
        eor     #$ff
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     charl5 
        lda     #$21
        jsr     waitkbs 
        
pic:       
        lda     #(S1D_SETPAGE0)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
pic0    lda     $d20a       ;A800,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     pic0
        
        lda     #(S1D_SETPAGE1)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
pic1    lda     $d20a       ;A800+162,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     pic1     
        
        lda     #(S1D_SETPAGE2)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
pic2    lda     $d20a       ;A800+162+162,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     pic2
        
        lda     #(S1D_SETPAGE3)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
pic3    lda     font8x8,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     pic3
        
        lda     #(S1D_SETPAGE4)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
pic4    lda     font8x8,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     pic4
        
        lda     #(S1D_SETPAGE5)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
pic5    lda     $d20a       ;A800+162+162+162+162+162,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     pic5
        
        lda     #(S1D_SETPAGE6)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
pic6    lda     $d20a       ;A800+162+162+162+162+162+162,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     pic6
        
        lda     #(S1D_SETPAGE7)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
pic7    lda     $d20a       ;A800+162+162+162+162+162+162+162,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     pic7
        
        lda     keycode
        cmp     #$0c
        beq     stop
            
        jmp     pic
        
stop:
        
                
        
        ;lda     #$21
        ;jsr     waitkbs 
                
        brk

;subroutines

waitkbs:
        pha
              
        lda     #$ff
        sta     keycode
        
        pla
        
kbloop  cmp     keycode
        bne     kbloop
        
        rts

        ICL "VIA6522.asm"
        ICL "S1D15705.asm"
        
