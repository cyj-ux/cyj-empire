#-----------------------------------------------#
#						#
#	 	makefile elotro			#
#						#
#-----------------------------------------------#

BIN = elotro
CFLAGS = -g -Wall -Wextra 
CC = gcc
AS = as
LD = ld
AS_FLAGS = -32
LD_FLAGS = -melf_i386
OBJ_FLAGS = -drwC -M att,i8086
DIR_COMP = /media/sf_Compartidos/bin/elotro

.PHONY: all 
 
elotro.bin:mbr.bin funcint10.bin funcint13.bin gdt.bin kernel.bin datos.bin datos1.bin datos2.bin
	cat bin/mbr.bin bin/datos.bin bin/datos1.bin bin/datos2.bin bin/kernel.bin > bin/elotro.bin
	cp bin/elotro.bin /media/sf_Compartidos/bin/elotro
	
mbr.bin: src/mbr.s
	as -o obj/mbr.o src/mbr.s
	ld -o bin/mbr.bin obj/mbr.o -e _start --oformat binary -Ttext 0x07c00
	objdump $(OBJ_FLAGS) obj/mbr.o > dump/mbr.dump
	
kernel.bin: src/kernel.s
	as -o obj/kernel.o src/kernel.s 
	ld -o bin/kernel.bin obj/kernel.o obj/funcint10.o obj/funcint13.o obj/gdt.o -e _main --oformat binary -Ttext 0x02000
	objdump $(OBJ_FLAGS) obj/kernel.o > dump/kernel.dump

funcint10.bin: src/funcint10.s
	as -o obj/funcint10.o src/funcint10.s 
	ld -o bin/funcint10.bin obj/funcint10.o -e 0x02200 --oformat binary -Ttext 0x02200
	objdump $(OBJ_FLAGS) obj/funcint10.o > dump/funcint10.dump
	
funcint13.bin: src/funcint13.s
	as -o obj/funcint13.o src/funcint13.s 
	ld -o bin/funcint13.bin obj/funcint13.o -e 0x02400 --oformat binary -Ttext 0x02400
	objdump $(OBJ_FLAGS) obj/funcint13.o > dump/funcint13.dump
	
gdt.bin: src/gdt.s
	as -o obj/gdt.o src/gdt.s 
	ld -o bin/gdt.bin obj/gdt.o -e 0x02600 --oformat binary -Ttext 0x02600
	objdump $(OBJ_FLAGS) obj/gdt.o > dump/gdt.dump
	
datos.bin: src/datos.s
	as -o obj/datos.o src/datos.s 
	ld -o bin/datos.bin obj/datos.o -e 0x0 --oformat binary -Ttext 0x0
	objdump $(OBJ_FLAGS) obj/datos.o > dump/datos.dump
		
datos1.bin: src/datos1.s
	as -o obj/datos1.o src/datos1.s 
	ld -o bin/datos1.bin obj/datos1.o -e 0x0200 --oformat binary -Ttext 0x0200
	objdump $(OBJ_FLAGS) obj/datos1.o > dump/datos1.dump
		
datos2.bin: src/datos2.s
	as -o obj/datos2.o src/datos2.s 
	ld -o bin/datos2.bin obj/datos2.o -e 0x0400 --oformat binary -Ttext 0x0400
	objdump $(OBJ_FLAGS) obj/datos2.o > dump/datos2.dump
	
.PHONY: mr.proper
mr.proper:
	rm -rf obj/*.o bin/*.bin obj/*.obj dump/*.dump


