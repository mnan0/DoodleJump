# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	fry: .word 1
	displayAddress: .word 0x10008000
.text
	lw $t0,displayAddress	#$t0 = displayAddress
	li $t1,0xff0000	#$t1 = red
	sw $t1, 0($t0)
	lw $t2, 0($t0)
	
	
EXIT: 	li $v0 10
	syscall
