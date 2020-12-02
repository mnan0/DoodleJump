# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	fry: .word 1
	displayAddress: .word 0x10008000
.text
	# NESTED FUNCTION TEST
	addi $a0,$a0,2
	addi $a1,$a1,1
	jal multiply_four
	add $t0,$zero,$v0
	j EXIT
multiply_four: 
	sll $v0,$a0,2
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal add_function
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
add_function	:add $v0,$v0,$a1
	jr $ra
	
EXIT: 	li $v0 10
	syscall
