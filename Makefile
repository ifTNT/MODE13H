all:clean test/test.exe run


dragon:dragon/dragon.exe
	@echo [Running]
	@dosbox -c "mount C $(shell pwd)" \
		   -c "C:" \
		   -c "dragon\\dragon.exe" \
		   -c "exit"

run:
	@echo [Running]
	@dosbox -c "mount C $(shell pwd)" \
		   -c "C:" \
		   -c "test\\test.exe" \
		   -c "exit"

%.exe:%.obj
	dosbox -c "mount C $(shell pwd)" \
			-c "C:" \
			-c "TLINK /s $(subst /,\\,$^), $(subst /,\\,$@) > __LINKER.TXT" \
			-c "exit" > /dev/null
	@echo [Linking]
	@cat __LINKER.TXT
	@rm -f __LINKER.TXT

%.obj:%.asm 
	@echo [Assembling]
	nasm -f obj -o $@ $^

clean:
	@echo Cleaning up...
	rm -f test/TEST.EXE test/test.obj test/TEST.MAP \
	      dragon/dragon.obj dragon/DRAGON.EXE dragon/DRAGON.MAP
