.file "gdt.s"
.set SECTDATOS, 0x02600
.set SEGCODE, 0x010
.set SEGDATA, 0x018
.set MEMVIDEO, 0x0b8000
.set CHAR, 0x0741       # 'A'
.set ADDRFIRMA, 0x01fe
.set SECTFIRMA, 0xaa55

.code16 				# code 16 bits
.text

.globl cargargdt
cargargdt:

	movw $0x02600, %ax	# $0x02600      0x07c00
	movw %ax, %ds
#	movw %ax, %es

    # Indice 0x00
.align 8				# Fuerza alineamiento 8 bytes
gdt_start:				# Null segmento 32 bits
    # 0x8
    .long 0x0           # .byte 0x00, 0x00, 0x00, 0x00;
    .long 0x0
    # 0x10
gdt_code:				# Segmento de code descriptor
	.word 0x0ffff 		# limite bajo 16 bits
	.word 0x0			# base bajo 16 bits
	.byte 0x0			# base medio 8 bits
	.byte 0b010011010	# acceso byte 0x09a 8 bits
	.byte 0b011001111 	# flags 0xcf 8 bits
	.byte 0x0			# base alto 8 bits
 
gdt_data:				# Segmento de data descriptor
    # 0x18
	.word 0x0ffff 		# limite bajo
	.word 0x0			# base bajo
	.byte 0x0			# base medio
	.byte 0b010010010	# acceso        0x092
	.byte 0b011001111 	# granularidad  0x0cf
	.byte 0x0			# base alto

gdt_end:
.align 4
gdt_descriptor :
    .word gdt_end - gdt_start - 1   # tamaño del GDT
	.long gdt_start                 # comienzo del GDT

#	cli 
#	movw $SEGDATOS, %ax
#	movw %ax, %ds
	lgdt (gdt_descriptor)		# 0x02620 (gdt_descriptor)
#	sti 
	
	movl %cr0, %eax
	or $1, %eax
	movl %eax, %cr0

	ljmp $SEGCODE, $start32	# ljmp $0x08, $start32 
					            # jmp $CODE_SEG, $start32
										
.code32 			        	# code 32 bits
start32:
	nop
    xor %eax, %eax
#	cli
	movw $SEGDATA, %ax       	# movw $0x010, %ax 		
	movw %ax, %ds		    	# movw $DATA_SEG, %ax
	movw %ax, %ss
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %gs 
	
#	movl $0x090000, %ebp
#	movl %ebp, %esp
#	sti
	
	movw $CHAR, 0x0b8000    	# imprime 'A' arriba a la izquierda,
					            # si no ha fallado.
ciclo:  
	hlt 
	jmp ciclo
	ret

.org ADDRFIRMA
.word SECTFIRMA

#.align 16
#gdt:
	# Index 0x00
	# Required dummy
#	.quad	0x00

	# 0x08
	# Unused
#	.quad	0x00

	# 0x10
	# protected mode code segment
	# bit 63			bit 32
	# 000000000000000 | 1001101000000000
	# 000000000000000 | 1111111111111111 (limit)
	# bit 31 (base)		bit 0
	#.word	0xFFFF
	#.word	0x0000
	#.word	0x9A00	# 1001 1010 0000 0000
	#.word	0x00CF	# 0000 0000 1100 1111
#	.quad 0x00cf9a000000ffff	

	# 0x18
	# protected mode data segment
	#.word	0xFFFF
	#.word	0x0000
	#.word	0x9200 # 1001 0010 0000 0000
	#.word	0x00CF # 0000 0000 1100 1111 
#	.quad 0x00cf92000000ffff	

