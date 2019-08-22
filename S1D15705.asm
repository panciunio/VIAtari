/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 */
 
; name: S1D15705.asm
;
; This is program which is demonstrating how to use S1D15705 connected via VIA ports with Atari .
; Available functions:
;



 
 
;VIA initialisation:

via_init:   lda #%11111111  ;   all bits of PORTB as output
            jsr VIA_PBset
            
            lda #%00011111  ;   5 lower bits of PORTA as output
            jsr VIA_PAset   ;   4 - CS1, 3- RESET, 2 - A0, 1 - WR, 0 - RD
            rts
  
;lcd_write_command:
;   A - command to send

lcd_write_cmd:  
            sta S1D15705_DATAPORT               ; set command
            pha

            lda #$ff
            and #S1D15705_CS_N
            sta S1D15705_CTRLPORT               ; set chip  enabled
            and #S1D15705_A0_N
            sta S1D15705_CTRLPORT               ; command type
            and #S1D15705_WR_N
            sta S1D15705_CTRLPORT               ; send command
            
            ;nop
            ;nop
            ;nop
            nop
            
            ora #S1D15705_WR
            sta S1D15705_CTRLPORT               
            ora #S1D15705_CS
            sta S1D15705_CTRLPORT
            
            pla             
            rts
            
;lcd_write_data
;   A - data to send

lcd_write_data: 
            sta S1D15705_DATAPORT               ; set command
            pha
            
            lda #$ff
            and #S1D15705_CS_N
            sta S1D15705_CTRLPORT               ; set chip  enabled
            
            and #S1D15705_WR_N
            sta S1D15705_CTRLPORT               ; send data
            
            ;nop
            ;nop
            ;nop
            nop

            ora #S1D15705_WR
            sta S1D15705_CTRLPORT               
            ora #S1D15705_CS
            sta S1D15705_CTRLPORT

            pla
            rts

lcd_read_stat:  
            tya
            pha
            
            lda #$ff
            and #S1D15705_CS_N
            sta S1D15705_CTRLPORT               ; set chip enabled
            and #S1D15705_A0_N
            sta S1D15705_CTRLPORT               ; command type
            
            ldy #$00
            sty S1D15705_DATAPORT_DIR           ; set DATAPORT as input         
            
            and #S1D15705_RD_N
            sta S1D15705_CTRLPORT               ; send status command
            
            lda S1D15705_DATAPORT               ; store status in A
            
            ldy #$ff
            sty S1D15705_DATAPORT_DIR           ; set DATAPORT as output
            
            pla
            tay
            
            rts
            

;lcd_clear:
;lcd_pfill:
lcd_clear:  lda #$00
            sta pattern
lcd_pfill:  ldy #(S1D_SETPAGE)
fillploop1  tya
            jsr lcd_write_cmd
            lda #S1D_STARTLINE
            jsr lcd_write_cmd        
            
            jsr pfill
            
            iny
            cpy #(S1D_SETPAGE +9)
            bne fillploop1
            rts
            
pfill   lda     #S1D_SETCOLL_L
        jsr     lcd_write_cmd
        
        ldx     #$00
        lda     pattern
        
pfloop  jsr     lcd_write_data
        inx
        cpx #170
        bne pfloop
        rts

;frm2lcd - send frame from RAM to LCD memory
;
frm2lcd:

        pha
        txa
        pha
        tya
        pha
        
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
        cpx     #(LCD_MAX_COLlS)   
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
        cpx     #(LCD_MAX_COLlS)   
        bne     page1     
        
        lda     #(S1D_SETPAGE2)
        jsr     lcd_write_cmd       
        lda     #S1D_STARTLINE
        jsr     lcd_write_cmd       ; set first column
        lda     #(S1D_SETCOLL_L+3)
        jsr     lcd_write_cmd
        ldx     #$00
page2   lda     lcd_page2,x
        jsr     lcd_write_data
        inx
        cpx     #(LCD_MAX_COLlS)
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
        cpx     #(LCD_MAX_COLlS)
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
        cpx     #(LCD_MAX_COLlS)
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
        cpx     #(LCD_MAX_COLlS)
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
        cpx     #(LCD_MAX_COLlS)
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
        cpx     #(LCD_MAX_COLlS)
        bne     page7 
        
        pla
        tay
        pla
        tax
        pla               
        rts

frmclear:
        ldx #$0
        lda #$0
        sta pattern
frmfill:
        lda pattern
frmfl   sta lcd_page0,x
        sta lcd_page1,x
        sta lcd_page2,x
        sta lcd_page3,x
        sta lcd_page4,x
        sta lcd_page5,x
        sta lcd_page6,x
        sta lcd_page7,x
        inx
        cpx #(LCD_MAX_COLLS)
        bne frmfl
        rts
        
;C-color (0..1), Y-x coord (0..161), X-y coord (0..63)

plot:
        lda rowadl,x
        sta adr
        lda rowadh,x
        sta adr+1

        lda (adr),y
        and masktab,x
        scc
        ora pixeltab,x
        sta (adr),y
        rts

        
;lcd_init:

lcd_init:   
            lda #$00
            sta S1D15705_CTRLPORT   ;perform RESET
            
            nop
            nop
            nop            
                        
            lda #$ab        ; oscillator ON
            jsr lcd_write_cmd 
                
            lda #$a3        ; LCD bias value   1/9
            jsr lcd_write_cmd
            
            lda #S1D_DISROT_RR      ; enable inversion
            jsr lcd_write_cmd
            
            lda #S1D_COMOUTSS_RR    ; disable mirroring
            jsr lcd_write_cmd

            lda #$40        ; line 0
            jsr lcd_write_cmd
   
            lda #$2b        ; power control set to 2
            jsr lcd_write_cmd
                    
            lda #$26        ; voltage adjusting 5V
            jsr lcd_write_cmd
            
            lda #$81        ; Electronic control 1
            jsr lcd_write_cmd

            lda #$13        ; Electronic control 2
            jsr lcd_write_cmd
            
            lda #$af        ; LCD ON
            jsr lcd_write_cmd
            
            lda #$a5        ; All lighting ON
            jsr lcd_write_cmd
            
            lda #$a4        ; All lighting OFF
            jsr lcd_write_cmd

            rts
            
;Load S1D15705 registers description
 
            ICL "S1D15705.inc"
