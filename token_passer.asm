PROCESSOR 10F200
#include "p10f200.inc"
	
	; HTdly - Width of HasToken pulse
	; Tdly  - Width of token

	HT	equ	GP0
	RT	equ	GP1
	TO	equ	GP2
	TI	equ	GP3

	; Disable reset pin, code protection and watchdog timer
	__CONFIG _MCLRE_OFF & _CP_OFF & _WDT_OFF

	org	0x00
	
	movlw	b'11011111'	; Disable Timer input on GP2 pin
	option
	
	movlw	b'00001010'	; Set GP0 and GP2 to output
	tris	GPIO

Loop:	bsf	GPIO, GP2
	call	Tdly
	bcf	GPIO, GP2
	call	Tdly
	goto Loop


HTdly:	retlw	0x00		; 1uS delay (2clk for call, 2clk for retlw)

Tdly:	nop			; 5uS delay
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	retlw	0x00

	end
