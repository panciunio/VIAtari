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
                
        ldx     #$00
charl0  lda     font5x8,x                                                   
        eor     #$ff
        sta     lcd_page0,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)      
        bne     charl0
        
        jsr     frm2lcd
         
        lda     #$21
        jsr     waitkbs     
 
        
        ldx     #$00
charl1  lda     $e200,x
        sta     lcd_page1,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)      
        bne     charl1
        
        jsr     frm2lcd
        
        
        
        lda     #$21
        jsr     waitkbs

        
        ldx     #$00                ; get data from Atari chars generator (ROM)
charl2  lda     $e100,x
        sta     lcd_page2,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)     
        bne     charl2
        
        jsr     frm2lcd
        
        lda     #$21
        jsr     waitkbs


        
        ldx     #$00
charl3  lda     $e100,x
        sta     lcd_page3,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)    
        bne     charl3    
        
        jsr     frm2lcd
       
        lda     #$21
        jsr     waitkbs             


        
        ldx     #$00
charl4  lda     $e100,x
        sta     lcd_page4,x
        inx
        cpx     #(LCD_MAX_COLLS - 2)     
        bne     charl4 

        jsr     frm2lcd

        lda     #$21
        jsr     waitkbs     
        

        
        ldx     #$00
charl5  lda     font8x8,x
        eor     #$ff
        sta     lcd_page5,x
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     charl5 
        
        jsr     frm2lcd
        
        lda     #$21
        jsr     waitkbs 



        
mloop   ;jsr     frm2lcd     ;show frame

        lda     random
        sta     pattern
        jsr     lcd_pfill
        
        lda     keycode
        cmp     #$0c
        beq     stop
            
        jmp     mloop

stop:
        brk



;subroutines


frm2lcd:
        lda     #(S1D_SETPAGE0)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
page0   lda     lcd_page0,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     page0
        
        lda     #(S1D_SETPAGE1)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
page1   lda     lcd_page1,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     page1     
        
        lda     #(S1D_SETPAGE2)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
page2   lda     lcd_page3,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     page2
        
        lda     #(S1D_SETPAGE3)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
page3   lda     lcd_page3,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     page3
        
        lda     #(S1D_SETPAGE4)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
page4   lda     lcd_page4,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     page4
        
        lda     #(S1D_SETPAGE5)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
page5   lda     lcd_page5,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     page5
        
        lda     #(S1D_SETPAGE6)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
page6   lda     lcd_page6,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     page6
        
        lda     #(S1D_SETPAGE7)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
page7   lda     lcd_page7,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS - 2)    ;don't fill last 2 colls  
        bne     page7
        
        rts
        


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
 
