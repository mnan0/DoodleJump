# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	fry: .word 1
.text
	lw $t0, num
	addi $t1, $t1, 1
	sw $t1, num($t0)
	
EXIT: 	li $v0 10
	syscall