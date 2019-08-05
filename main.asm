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



         ORG   $6000
         
;main program         
        
         
start   jsr     via_init
        jsr     lcd_init
        jsr     lcd_clear
       
        lda     #$aa                ; write zebra to LCD memory
        sta     pattern
        jsr     lcd_pfill

 ;test lcd 
 

        lda     #(S1D_SETPAGE)
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
        cpx     #170        
        bne     charl0      
 
        lda     #(S1D_SETPAGE+1)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L +3)
        jsr     lcd_write_cmd
        
        ldx     #$00
charl1  lda     $e100,x
        jsr     lcd_write_data
        inx
        cpx     #170        
        bne     charl1
        
        lda     #(S1D_SETPAGE+2)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L +3)
        jsr     lcd_write_cmd
        
        ldx     #$00
charl2  lda     $e200,x
        jsr     lcd_write_data
        inx
        cpx     #170        
        bne     charl2
        
        lda     #(S1D_SETPAGE+3)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L +3)
        jsr     lcd_write_cmd
        
        ldx     #$00
charl3  lda     $e300,x
        jsr     lcd_write_data
        inx
        cpx     #170        
        bne     charl3              
        
        brk


        ICL "VIA6522.asm"
        ICL "S1D15705.asm"
        
