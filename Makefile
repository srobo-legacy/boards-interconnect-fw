FW=/opt/ICDfw

all: token_passer.hex token_generator.hex

%.hex: %.asm
	gpasm $<

.PHONY: clean flash-tp flash-tg

flash-tp: token_passer.hex
	piklab-prog -p icd2 -d 10F200 -c program token_passer.hex -t usb --firmware-dir ${FW} --target-self-powered false

flash-tg: token_generator.hex
	piklab-prog -p icd2 -d 10F200 -c program token_generator.hex -t usb --firmware-dir ${FW} --target-self-powered false

clean:
	-rm -f token_{passer,generator}.{cod,hex,lst}
