;Please set base address for VIA6522
;
VIAbase     equ $d500



;VIA6522 registers
VIA_ORB     equ VIABASE + 0    ;    Output Register "B",   Input Register "B"
VIA_ORA     equ VIABASE + 1    ;    Output Register "A",   Input Register "A"
VIA_DDRB    equ VIABASE + 2    ;    Data Direction Register "B"
VIA_DDRA    equ VIABASE + 3    ;    Data Direction Register "A"
VIA_T1C_L   equ VIABASE + 4    ;    T1 Low-Order Latches,  T1 Low-Order Counter
VIA_T1C_H   equ VIABASE + 5    ;    T1 High-Order Counter
VIA_T1L_L   equ VIABASE + 6    ;    T1 Low-Order Latches
VIA_T1L_H   equ VIABASE + 7    ;    T1 High-Order Latches
VIA_T2C_L   equ VIABASE + 8    ;    T2 Low-Order Latches,  T2 Low-Order Counter
VIA_T2C_H   equ VIABASE + 9    ;    T2 High-Order Counter
VIA_SR      equ VIABASE + 10   ;    Shift Register
VIA_ACR     equ VIABASE + 11   ;    Auxiliary Control Register
VIA_PCR     equ VIABASE + 12   ;    Peripheral Control Register
VIA_IFR     equ VIABASE + 13   ;    Interrupt Flag Register
VIA_IER     equ VIABASE + 14   ;    Interrupt Enable Register
VIA_HNDS    equ VIABASE + 15   ;    Same as Reg 1 except no "Handshake"

PA0 equ 1
PA1 equ 2
PA2 equ 4
PA3 equ 8
PA4 equ 16
PA5 equ 32
PA6 equ 64
PA7 equ 128

PB0 equ 1
PB1 equ 2
PB2 equ 4
PB3 equ 8
PB4 equ 16
PB5 equ 32
PB6 equ 64
PB7 equ 128



