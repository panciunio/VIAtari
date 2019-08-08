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


;Load S1D15705 registers description
 
            ICL "S1D15705.inc"
 
 
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
            
            nop
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
            
            nop
            nop
            nop
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

lcd_clear:  ldy #(S1D_SETPAGE)
clearloop1  tya
            jsr lcd_write_cmd
            lda #S1D_STARTLINE
            jsr lcd_write_cmd        
            
            jsr cfill
            
            iny
            cpy #(S1D_SETPAGE +9)
            bne clearloop1
            rts
            
cfill       lda #S1D_SETCOLL_L
            jsr lcd_write_cmd
        
            ldx #$00
            lda #$00

floop       jsr lcd_write_data
            inx
            cpx #170
            bne floop
            rts
        
        
;lcd_pfill:
        
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


;lcd_init:

lcd_init:   lda #$ab        ; oscillator ON
            jsr lcd_write_cmd 
                
            lda #$a3        ; LCD bias value   1/9
            jsr lcd_write_cmd
            
            lda #$a7        ; enable inversion
            jsr lcd_write_cmd
            
            lda #$c8        ; disable mirroring
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
