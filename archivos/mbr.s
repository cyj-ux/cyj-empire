#
.set PRT_OFF,0x1be		# Partition table
.set MAGIC,0xaa55		# Magic: bootable
.set OFF_KERNEL, 0x02000	# Offset del kernel
.set OFF_DATA, 0x03000		# Offset de datos	
.set OFF_STACK, 0x04000		# Offset del stack

.code16
.globl _start
_start:		
	cli
	cld
	
	movw $0x0, %ax
	movw %ax, %ds
	movw %ax, %es
	
	movw $LC1, %si			
	call imp_cadena	
	movw $LC2, %si			
	call imp_cadena	
	movw $LC3, %si			
	call imp_cadena
	
	movb $0x0a, %al
	call imp_char
	movb $0x0d, %al
	call imp_char
	
sector2:			# datos
	mov $0x08000, %ax	# Ponemos el sector en esta direccion.
	mov %ax, %es		# igualamos el segmento extra.
	xor %bx, %bx		# limpiamos bx.
	mov $3, %al		# leemos tres sectores.
	mov $0, %ch		# segundo sector, track 0.
	mov $2, %cl		# sector 2. datos,  datos 1 y datos 2
	mov $0, %dh		# numero cabeza.
	mov $0, %dl		# numero unidad, floppy 0.
	mov $2, %ah		# funcion 2 de la int 13.
	int $0x13
	
	push %ax		# muestra resultado de int 10
	addb $48, %al
	call imp_char
	movb $' ', %al
	call imp_char
	pop %ax
	movb %ah, %al
	addb $48, %al
	call imp_char
	movb $' ', %al
	call imp_char
	
sector5:			# kernel
	mov $0x02000, %ax	# Pondremos el sector en esta direccion.
	mov %ax, %es		# igualamos el segmento extra.
	xor %bx, %bx		# limpiamos bx.
	mov $3, %al		# leemos tres sectores.
	mov $0, %ch		# segundo sector, track 0.
	mov $5, %cl		# sector 5.
	mov $0, %dh		# numero cabeza.
	mov $0, %dl		# numero unidad, floppy 0.
	mov $2, %ah		# funcion 2 de la int 13.
	int $0x13
	
	push %ax		# muestra resultado de int 10
	addb $48, %al
	call imp_char
	movb $' ', %al
	call imp_char
	pop %ax
	movb %ah, %al
	addb $48, %al
	call imp_char
	
	ljmp $0x02000, $0	# Vamos a la direccion del kernel
	
	hlt
	
	ret
	
#____________________________________________

.globl imp_cadena
imp_cadena:				# Poner la cadena en %si
	pusha
	movb $0x0e, %ah
	movw $0x7, %bx			# atributo de la pagina
	
rep:	lodsb        
	cmpb $0, %al
	je salir	
	int $0x010
	jmp rep
	
salir:  popa
	ret
	
#____________________________________________

.globl imp_char
imp_char:				# Poner el char en %al
	movb $0x0e, %ah			# 0x0e, modo tty
	movw $0x7, %bx			# atributo de la pagina
	int $0x010			# int 0x10
	ret
	
#____________________________________________

.org 0x0150

LC1:		
.asciz "\r\nCabronazo y Joputa, Inc.\r\n"
LC2:
.asciz "Bienvenid@ a mi nuevo sistema operativo.\r\n"
LC3:
.ascii "Version: 2.2.1b, ene. 2025.\r\n\0"

#____________________________________________
/*
.org 0x01be			# Tabla de particion 1

.byte 0x80 		# Atributos unidad, 1 bytes, bit 7 = 1, bootable	
.byte 0x01		# Direccion CHS de comienzo particion, 3 bytes.
.byte 0x01
.byte 0	 
.byte 6			# Tipo de particion, 1 byte. 
.byte 0x03f		# Direccion CHS de comienzo del ultimo sector, 3 bytes.
.byte 0x03f
.byte 0x0c4
.byte 0x03f		# LBA del comienzo de la particion, 4 bytes.
.byte 0
.byte 0
.byte 0			
.byte 0x081		# Numero de sectores en la particion, 4 bytes.
.byte 0x01e
.byte 0x00c
.byte 0
*/		
.org 0x01ce			# Tabla de particion 2
.org 0x01de			# Tabla de particion 3
.org 0x01ee			# Tabla de particion 4

.space 510-(.-_start)
# .org 0x01fe 			# 510
.word MAGIC			# Magic number
kernel:
.org 0x0200
