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
d3var:	equ	0x12

	; Disable reset pin, code protection and watchdog timer
	__CONFIG _MCLRE_OFF & _CP_OFF & _WDT_OFF

	org	0x00
	
	movlw	b'10011111'	; Disable Timer input on GP2 pin
	option
	
	movlw	b'00001011'	; Set GP2 to output
	tris	GPIO

	bsf	GPIO, TO	; Clear TO line, GPIO is undefined after POR

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

	movlw	d'100'		; 10ms debouncing delay
	movwf	d3var
d3:	call	Pdly
	decfsz	d3var, 1
	goto	d3

WaitGT:	btfss	GPIO, GenT	; Wait for GenT to go high before generating
	goto	WaitGT

	bcf	GPIO, TO	; Generate token
	call	Tdly
	bsf	GPIO, TO


; TI checking/token propagating
TIif:	btfsc	GPIO, TI	; Skip next if set
	goto	Loop

SendT:	btfss	GPIO, TI	; Wait for TI to clear before sending token
	goto	SendT

	btfss	GPIO, RemT	; Don't propagate token if it's to be removed
	goto	Loop

	bcf	GPIO, TO
	call	Tdly
	bsf	GPIO, TO

	goto Loop


Tdly:	nop			; 7us delay
	nop
	nop
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
