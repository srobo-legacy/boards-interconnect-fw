FW=/opt/ICDfw

all: token_passer.hex

token_passer.hex: token_passer.asm
	gpasm token_passer.asm

.PHONY: clean flash

flash: token_passer.hex
	piklab-prog -p icd2 -d 10F200 -c program token_passer.hex -t usb --firmware-dir ${FW}

clean:
	-rm -f token_passer.{cod,hex,lst}
