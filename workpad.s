# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	purple: .word 0x8e44ad
	black: .word 0x17202a
	yellow: .word 0xf7dc6f
	skyBlue: .word 0xaed6f1
	displayAddress: .word 0x10008000
	rocketPos: .word 15,25
	
.text
	# jump
	li $a0,60	#pitch
	li $a1,250	#duration
	li $a2,85	# instrument
	li $a3,100	# volume
	li $v0,31
	#syscall
	# spring
	li $a0,40
	li $a1,250
	li $a2,38
	li $a3,100
	li $v0,31
	#syscall
	# rocket
	li $a0,60
	li $a1,2800
	li $a2,126
	li $a3,100
	li $v0,31
	#syscall
	# notification
	li $a0,60
	li $a1,1000
	li $a2,9
	li $a3,140
	li $v0,31
	#syscall
	li $a0,60
	li $a1,200
	li $a2,0
	li $a3,80
	syscall
EXIT: 	li $v0, 10
	syscall
# Behaviour: Converts (x,y) into hexadecimal, given a base address (buffer or bitmap)
convXY_func:		# push $t0,$t1,$t2 on stack
		addi $sp,$sp,-4
		sw $t0,0($sp)
		addi $sp,$sp,-4
		sw $t1,0($sp)
		addi $sp,$sp,-4
		sw $t2,0($sp)
		add $t0,$zero,$a2	#a0 = x-value
		add $t1,$zero,$zero	#a1 = y-value
		add $t2, $zero,$zero	#a2 = address
CONVXL_BEGIN:	beq $t1,$a0,CONVXL_END	
		addi $t0,$t0,4
		addi $t1, $t1,1
		j CONVXL_BEGIN
CONVXL_END:		beq $t2, $a1,CONVYL_END
		addi $t0,$t0,128
		addi $t2, $t2,1
		j CONVXL_END
CONVYL_END:		add $v0,$zero,$t0	#return $v0 = hex address
		# pull $t2, $t1, $t0 off stack
		lw $t2,0($sp)
		addi $sp,$sp,4
		lw $t1,0($sp)
		addi $sp,$sp,4
		lw $t0,0($sp)
		addi $sp,$sp,4
		jr $ra