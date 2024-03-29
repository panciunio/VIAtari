;PORT/PIN settings for S1D15705

S1D15705_RD     equ PA0
S1D15705_WR     equ PA1
S1D15705_A0     equ PA2
S1D15705_RES    equ PA3
S1D15705_CS     equ PA4

S1D15705_D0     equ PB0
S1D15705_D1     equ PB1
S1D15705_D2     equ PB2
S1D15705_D3     equ PB3
S1D15705_D4     equ PB4
S1D15705_D5     equ PB5
S1D15705_D6     equ PB6
S1D15705_D7     equ PB7

S1D15705_RD_N     equ ($ff - S1D15705_RD)
S1D15705_WR_N     equ ($ff - S1D15705_WR)
S1D15705_A0_N     equ ($ff - S1D15705_A0)
S1D15705_RES_N    equ ($ff - S1D15705_RES)
S1D15705_CS_N     equ ($ff - S1D15705_CS)


S1D15705_DATAPORT       equ VIA_ORB
S1D15705_DATAPORT_DIR   equ VIA_DDRB

S1D15705_CTRLPORT       equ VIA_ORA
S1D15705_CTRLPORT_DIR   equ VIA_DDRA



;Control/status register 
;Status     |  BUSY | ADC | ON/OF | RESET | 0 | 0 | 0 | 0 |


;S1D15705 Read status:
CR_BUSY  equ   %10000000   ;  Operation stil in progress  0 - busy, 1- ready to next instruction
CR_ADC   equ   %01000000   ;  Screen invesion. 0 - inversion enabled, 1 - inversion disabled
CR_ONOF  equ   %00100000   ;  Display on/of. 0 - display is on
CR_RESET equ   %00010000   ;  1 - display during reset procedure, all commands except Read Status are ignored
CR_NA3   equ   %00001000   ;  n/a
CR_NA2   equ   %00000100   ;  n/a
CR_NA1   equ   %00000010   ;  n/a
CR_NA0   equ   %00000001   ;  n/a

;commands
S1D_DISPLAYON       equ %10101111   
S1D_DISPLAYOFF      equ %10101110
S1D_STARTLINE       equ %01000000   ;value from 01000000 to 01111111
S1D_SETPAGE         equ %10110000   ;value from 10110000 to 10111000 
S1D_SETPAGE0        equ %10110000   
S1D_SETPAGE1        equ %10110001   
S1D_SETPAGE2        equ %10110010   
S1D_SETPAGE3        equ %10110011   
S1D_SETPAGE4        equ %10110100   
S1D_SETPAGE5        equ %10110101   
S1D_SETPAGE6        equ %10110110   
S1D_SETPAGE7        equ %10110111   
S1D_SETCOLL_H       equ %00010000   ;value from 00010000 to 00011111 for A7, A6, A5, A4   
S1D_SETCOLL_L       equ %00000000   ;value from 00000000 to 00001111 for A3, A2, A1, A0
S1D_ADCSEL_NR       equ %10100000   ;ADC Select (Segment Driver Direction Select) - Normal Rotation
S1D_ADCSEL_RR       equ %10100001   ;ADC Select (Segment Driver Direction Select) - Reversal Rotation
S1D_DISROT_NR       equ %10100110   ;Display Normal Rotation/Reversal - LCD on potential (normal rotation) RAM data HIGH
S1D_DISROT_RR       equ %10100111   ;Display Normal Rotation/Reversal - LCD on potential (reversal) RAM data LOW
S1D_COMOUTSS_NR     equ %11000000   ;Common Output State Selection - Normal rotation 
S1D_COMOUTSS_RR     equ %11001000   ;Common Output State Selection - Reversal
S1D_STINDIC_OFF     equ %10101100   ;Static Indicator OFF (second byre as data required: 0, 1 or 2)
S1D_STINDIC_ON      equ %10101101   ;Static Indicator ON (second byre as data required: 0, 1 or 2)
S1D_REVDRIREG       equ %00110000   ;n-Line Reversal Drive Register Set: 00110000 - 00111111
S1D_REVDRIRST       equ %11100100   ;n-Line Reversal Drive Reset

LCD_MAX_COLLS   equ 162  ; max LCD collumns 


;definitions
.define poke mva #%%2 %%1

    ORG   *


.array font5x8 .byte
$00, $00, $00, $00, $00 ; space 
$00, $00, $5F, $00, $00 ; !
$00, $07, $00, $07, $00 ; "
$14, $7F, $14, $7F, $14 ; #
$24, $2A, $7F, $2A, $12 ; $
$23, $13, $08, $64, $62 ; %
$36, $49, $55, $22, $50 ; &
$00, $05, $03, $00, $00 ; '
$00, $1C, $22, $41, $00 ; (
$00, $41, $22, $1C, $00 ; )
$08, $2A, $1C, $2A, $08 ; *
$08, $08, $3E, $08, $08 ; +
$00, $50, $30, $00, $00 ; ,
$08, $08, $08, $08, $08 ; -
$00, $30, $30, $00, $00 ; .
$20, $10, $08, $04, $02 ; /
$3E, $51, $49, $45, $3E ; 0
$00, $42, $7F, $40, $00 ; 1
$42, $61, $51, $49, $46 ; 2
$21, $41, $45, $4B, $31 ; 3
$18, $14, $12, $7F, $10 ; 4
$27, $45, $45, $45, $39 ; 5
$3C, $4A, $49, $49, $30 ; 6
$01, $71, $09, $05, $03 ; 7
$36, $49, $49, $49, $36 ; 8
$06, $49, $49, $29, $1E ; 9
$00, $36, $36, $00, $00 ; :
$00, $56, $36, $00, $00 ; ;
$00, $08, $14, $22, $41 ; <
$14, $14, $14, $14, $14 ; =
$41, $22, $14, $08, $00 ; >
$02, $01, $51, $09, $06 ; ?
$32, $49, $79, $41, $3E ; @
$7E, $11, $11, $11, $7E ; A
$7F, $49, $49, $49, $36 ; B
$3E, $41, $41, $41, $22 ; C
$7F, $41, $41, $22, $1C ; D
$7F, $49, $49, $49, $41 ; E
$7F, $09, $09, $01, $01 ; F
$3E, $41, $41, $51, $32 ; G
$7F, $08, $08, $08, $7F ; H
$00, $41, $7F, $41, $00 ; I
$20, $40, $41, $3F, $01 ; J
$7F, $08, $14, $22, $41 ; K
$7F, $40, $40, $40, $40 ; L
$7F, $02, $04, $02, $7F ; M
$7F, $04, $08, $10, $7F ; N
$3E, $41, $41, $41, $3E ; O
$7F, $09, $09, $09, $06 ; P
$3E, $41, $51, $21, $5E ; Q
$7F, $09, $19, $29, $46 ; R
$46, $49, $49, $49, $31 ; S
$01, $01, $7F, $01, $01 ; T
$3F, $40, $40, $40, $3F ; U
$1F, $20, $40, $20, $1F ; V
$7F, $20, $18, $20, $7F ; W
$63, $14, $08, $14, $63 ; X
$03, $04, $78, $04, $03 ; Y
$61, $51, $49, $45, $43 ; Z
$00, $00, $7F, $41, $41 ; [
$02, $04, $08, $10, $20 ; "\"
$41, $41, $7F, $00, $00 ; ]
$04, $02, $01, $02, $04 ; ^
$40, $40, $40, $40, $40 ; _
$00, $01, $02, $04, $00 ; `
$20, $54, $54, $54, $78 ; a
$7F, $48, $44, $44, $38 ; b
$38, $44, $44, $44, $20 ; c
$38, $44, $44, $48, $7F ; d
$38, $54, $54, $54, $18 ; e
$08, $7E, $09, $01, $02 ; f
$08, $14, $54, $54, $3C ; g
$7F, $08, $04, $04, $78 ; h
$00, $44, $7D, $40, $00 ; i
$20, $40, $44, $3D, $00 ; j
$00, $7F, $10, $28, $44 ; k
$00, $41, $7F, $40, $00 ; l
$7C, $04, $18, $04, $78 ; m
$7C, $08, $04, $04, $78 ; n
$38, $44, $44, $44, $38 ; o
$7C, $14, $14, $14, $08 ; p
$08, $14, $14, $18, $7C ; q
$7C, $08, $04, $04, $08 ; r
$48, $54, $54, $54, $20 ; s
$04, $3F, $44, $40, $20 ; t
$3C, $40, $40, $20, $7C ; u
$1C, $20, $40, $20, $1C ; v
$3C, $40, $30, $40, $3C ; w
$44, $28, $10, $28, $44 ; x
$0C, $50, $50, $50, $3C ; y
$44, $64, $54, $4C, $44 ; z
$00, $08, $36, $41, $00 ; // {
$00, $00, $7F, $00, $00 ; // |
$00, $41, $36, $08, $00 ; // }
$08, $08, $2A, $1C, $08 ; ->
$08, $1C, $2A, $08, $08 ; <-
.enda

.array font8x8 .byte
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$ff, $81, $81, $81, $81, $81, $81, $ff ; empty square 
$00, $00, $00, $00, $00 ,$00, $00, $00 ; space
.enda

;.array pattern .byte
;$00
;.enda

pattern .byte   $00




rowadl:
:64     .byte <[screen+162*[#/8]]
rowadh:
:64     .byte >[screen+162*[#/8]]
masktab:
:64     .byte [1 << [# & %111]] ^ $ff
pixeltab:
:64     .byte [1 << [# & %111]]

screen  .ds 162*[64/8] 


lcd_page0   equ (screen)
lcd_page1   equ (screen + 162*1)
lcd_page2   equ (screen + 162*2)
lcd_page3   equ (screen + 162*3)
lcd_page4   equ (screen + 162*4)
lcd_page5   equ (screen + 162*5)
lcd_page6   equ (screen + 162*6)
lcd_page7   equ (screen + 162*7)


 
 
