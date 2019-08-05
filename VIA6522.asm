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
; name: VIA6522.asm
;
; This is program which is demonstrating how to use VIA6522 with Atari parallel bus.
; Available functions:
; 
;  Don't forget to set base address for VIA6522 in 'VIA6522.inc' file!


;Messages/ERRORS:

;Load VIA6522 registers description

         ICL "VIA6522.inc"


;variables





;VIA library

;VIA_PAset:
;   A - PORTA setting
;   Y - pool-up setting

VIA_PAset:  sta VIA_DDRA
            rts
    
;VIA_PBset:
;   A - PORTB setting
;   Y - pool-up setting

VIA_PBset:  sta VIA_DDRB
            rts
            
               
    



         

