;Please set base address for PCF8584
;
P8584       equ $d500
P8584_SX    equ 0
P8584_S1    equ 1

;Control/status register S1
;Control    |  PIN   |  ESO   |  ES1   |  ES2   |  ENI   |  STA   |  STO   |  ACK   |  WRITE ONLY
;Status     |  PIN   |  0/1   |  STS   |  BER   | AD0/LRB|  AAS   |  LAB   |  /BB   |  READ ONLY

;S1 WRITE MODE:
S1_PIN   equ   %10000000   ;  Pending Interrupt Not
S1_ESO   equ   %01000000   ;  Enable Serial Output
S1_ES1   equ   %00100000   ;  
S1_ES2   equ   %00010000   ;
S1_ENI   equ   %00001000   ;  External Interrupt Output Enable
S1_STA   equ   %00000100   ;  START control bit
S1_STO   equ   %00000010   ;  STOP control bit
S1_ACK   equ   %00000001   ;  ACK control bit

;S1 READ MODE
S1_PINR  equ   %10000000   ;  Pending Interrupt Not
S1_STS   equ   %00100000   ;  STOP condition detected flag
S1_BER   equ   %00010000   ;  Bus error detected flag
S1_LRB   equ   %00001000   ;  |Last received bit or Address 0 (General call)
S1_AD0   equ   %00001000   ;  |depend from AAS
S1_AAS   equ   %00000100   ;  Addressed As Slave bit
S1_LAB   equ   %00000010   ;  Lost Arbitration Bit
S1_BB    equ   %00000001   ;  Busy Bit flag


