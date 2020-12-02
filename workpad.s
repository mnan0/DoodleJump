# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	fry: .word 1
	displayAddress: .word 0x10008000
.text
	addi $t0,$zero,-1
	
	
EXIT: 	li $v0 10
	syscall
