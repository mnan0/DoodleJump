# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	fry: .word 1
.text
	la $t0, num
	lw $t4, 0($t0)
	
	
EXIT: 	li $v0 10
	syscall
