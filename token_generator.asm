PROCESSOR 10F200
#include "p10f200.inc"
	
	; HTdly - Width of HasToken pulse
	; Tdly  - Width of token

GenT:	equ	GP0
RemT:	equ	GP1
TO:	equ	GP2
TI:	equ	GP3

d1var:	equ	0x10
d2var:	equ	0x11

	; Disable reset pin, code protection and watchdog timer
	__CONFIG _MCLRE_OFF & _CP_OFF & _WDT_OFF

	org	0x00
	
	movlw	b'11011111'	; Disable Timer input on GP2 pin
	option
	
	movlw	b'00001011'	; Set GP2 to output
	tris	GPIO

	bcf	GPIO, TO	; Clear TO line, GPIO is undefined after POR

	; 2 second delay on reset
	movlw	d'200'		; 200 * 10ms = 2s
	movwf	d1var
d1:	movlw	d'100'		; 100 * 100us = 10ms
	movwf	d2var
d2:	call	Pdly
	decfsz	d2var, 1
	goto	d2
	decfsz	d1var, 1
	goto	d1


; GenT pin checking/token generating
Loop:	btfsc	GPIO, GenT	; Skip next if clear
	goto	TIif

WaitGT:	btfss	GPIO, GenT	; Wait for GenT to go high before generating
	goto	WaitGT

	bsf	GPIO, TO	; Generate token
	call	Tdly
	bcf	GPIO, TO


; TI checking/token propagating
TIif:	btfss	GPIO, TI	; Skip next if set
	goto	Loop

SendT:	btfsc	GPIO, TI	; Wait for TI to clear before sending token
	goto	SendT

	btfss	GPIO, RemT	; Don't propagate token if it's to be removed
	goto	Loop

	bsf	GPIO, TO
	call	Tdly
	bcf	GPIO, TO

	goto Loop


Tdly:	nop			; 5us delay
	retlw	0x00

Pdly:	call	Tdly		; 100us delay
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	call	Tdly
	retlw	0x00

	end
