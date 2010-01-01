all: token_passer.hex

token_passer.hex: token_passer.asm
	gpasm token_passer.asm

.PHONY: clean

clean:
	-rm -f token_passer.{cod,hex,lst}
