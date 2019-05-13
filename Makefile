all:clean test.exe run

test.exe:test/test.obj
	@dosbox -c "mount C $(shell pwd)" \
			-c "C:" \
			-c "TLINK test\test.obj, test.exe > __LINKER.TXT" \
			-c "exit" > /dev/null
	@echo [Linking]
	@cat __LINKER.TXT
	@rm -f __LINKER.TXT

run:
	@echo [Running]
	@dosbox -c "mount C $(shell pwd)" \
		   -c "C:" \
		   -c "test.exe" \
		   -c "exit"

%.obj:%.asm 
	@echo [Assembling]
	nasm -f obj -o $@ $^

clean:
	@echo Cleaning up...
	rm -f TEST.EXE test/test.obj TEST.MAP