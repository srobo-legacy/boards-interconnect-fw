PROCESSOR 10F200
#include "p10f200.inc"
	
	; HTdly - Width of HasToken pulse
	; Tdly  - Width of token

HT:	equ	GP0
RT:	equ	GP1
TO:	equ	GP2
TI:	equ	GP3

d1var:	equ	0x10
d2var:	equ	0x11

	; Disable reset pin, code protection and watchdog timer
	__CONFIG _MCLRE_OFF & _CP_OFF & _WDT_OFF

	org	0x00
	
	movlw	b'11011111'	; Disable Timer input on GP2 pin
	option
	
	movlw	b'00001010'	; Set GP0 and GP2 to output
	tris	GPIO

	bsf	GPIO, TO	; Clear TO line, GPIO is undefined after POR
	bcf	GPIO, HT	; Clear HT line too

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

Loop:	btfsc	GPIO, TI	; Skip next if set
	goto	Loop

	btfss	GPIO, RT	; Send token along if not requested
	goto	SendT
	bsf	GPIO, HT	; Indicate the presence of the token

WaitRT:	btfsc	GPIO, RT	; Only continue once RT is cleared
	goto	WaitRT
	bcf	GPIO, HT	; No more token for you

SendT:	btfss	GPIO, TI	; Wait for TI to clear before sending token
	goto	SendT
	bcf	GPIO, TO
	call	Tdly
	bsf	GPIO, TO

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
