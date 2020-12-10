# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	purple: .word 0x8e44ad
	black: .word 0x17202a
	yellow: .word 0xf7dc6f
	skyBlue: .word 0xaed6f1
	displayAddress: .word 0x10008000
	rocketPos: .word 15,25
	poggersPos: .word 9,12,10,12,11,12,9,13,11,13,9,14,10,14,11,14,9,15,9,16, #10
	13,12,14,12,15,12,13,13,15,13,13,14,15,14,13,15,15,15,13,16,14,16,15,16, #12
	17,12,18,12,19,12,20,12,17,13,17,14,17,15,17,16,18,16,19,16,20,16,20,15,20,14,19,14, #14
	22,12,22,13,22,14,22,16 #4
	
	epicPos: .word 8,12,9,12,10,12,8,13,8,14,9,14,10,14,8,15,8,16,9,16,10,16, #11
	12,12,13,12,14,12,12,13,14,13,12,14,13,14,14,14,12,15,12,16, #10
	16,12,16,13,16,14,16,15,16,16, #5
	18,12,19,12,20,12,18,13,18,14,18,15,18,16,19,16,20,16, #9
	22,12,22,13,22,14,22,16 #4
	
	coolPos: .word 8,12,9,12,10,12,8,13,8,14,8,15,8,16,9,16,10,16, #9
	12,12,13,12,14,12,12,13,14,13,12,14,14,14,12,15,14,15,12,16,13,16,14,16, #12
	16,12,17,12,18,12,16,13,18,13,16,14,18,14,16,15,18,15,16,16,17,16,18,16, #12
	20,12,20,13,20,14,20,15,20,16,21,16,22,16, #7
	24,12,24,13,24,14,24,16 #4
	
	nicePos: .word 7,12,7,13,7,14,7,15,7,16,8,13,9,14,10,15,10,16,10,14,10,13,10,12, #12
	12,12,12,13,12,14,12,15,12,16, #5
	14,12,15,12,16,12,14,13,14,14,14,15,14,16,15,16,16,16, #9
	18,12,19,12,20,12,18,13,18,14,19,14,20,14,18,15,18,16,19,16,20,16, #11
	22,12,22,13,22,14,22,16 #4
	
	goodPos: .word 7,12,8,12,9,12,10,12,7,13,7,14,7,15,7,16,8,16,9,16,10,16,10,15,10,14,9,14, #14
	12,12,13,12,14,12,12,13,14,13,12,14,14,14,12,15,14,15,12,16,13,16,14,16, #12
	16,12,17,12,18,12,16,13,18,13,16,14,18,14,16,15,18,15,16,16,17,16,18,16 #12
	22,12,22,13,22,14,21,14,20,14,20,15,22,15,20,16,21,16,22,16, #10
	24,12,24,13,24,14,24,16 #4
.text
	jal draw_good
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

#Behaviour: draw the word Pog
draw_poggers:	# push $ra, $t0,$t1,$t2,$t3,$t4 onto stack
		addi $sp,$sp,-4
		sw $ra,0($sp)
		addi $sp,$sp,-4
		sw $t0,0($sp)
		addi $sp,$sp,-4
		sw $t1,0($sp)
		addi $sp,$sp,-4
		sw $t2,0($sp)
		addi $sp,$sp,-4
		sw $t3,0($sp)
		
		add $t0,$zero,$zero
		addi $t1,$zero,40
		lw $t2,purple
		la $t3,poggersPos
drawPogLB:		beq $t0,$t1,drawPogLE
		lw $a0,0($t3)
		lw $a1,4($t3)
		lw $a2,displayAddress
		jal convXY_func
		sw $t2,0($v0)
		addi $t3,$t3,8
		addi $t0,$t0,1
		j drawPogLB
		# pull $t3,$t2,$t1,$t0,$ra off stack
drawPogLE:		lw $t3,0($sp)
		addi $sp,$sp,4
		lw $t2,0($sp)
		addi $sp,$sp,4
		lw $t1,0($sp)
		addi $sp,$sp,4
		lw $t0,0($sp)
		addi $sp,$sp,4
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draws "EPIC!"
draw_epic:		# push $ra, $t0,$t1,$t2,$t3,$t4 onto stack
		addi $sp,$sp,-4
		sw $ra,0($sp)
		addi $sp,$sp,-4
		sw $t0,0($sp)
		addi $sp,$sp,-4
		sw $t1,0($sp)
		addi $sp,$sp,-4
		sw $t2,0($sp)
		addi $sp,$sp,-4
		sw $t3,0($sp)
		
		add $t0,$zero,$zero
		addi $t1,$zero,39
		lw $t2,purple
		la $t3,epicPos
drawEpicLB:		beq $t0,$t1,drawEpicLE
		lw $a0,0($t3)
		lw $a1,4($t3)
		lw $a2,displayAddress
		jal convXY_func
		sw $t2,0($v0)
		addi $t3,$t3,8
		addi $t0,$t0,1
		j drawEpicLB
		# pull $t3,$t2,$t1,$t0,$ra off stack
drawEpicLE:		lw $t3,0($sp)
		addi $sp,$sp,4
		lw $t2,0($sp)
		addi $sp,$sp,4
		lw $t1,0($sp)
		addi $sp,$sp,4
		lw $t0,0($sp)
		addi $sp,$sp,4
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draws the word "COOL!"
draw_cool:		# push $ra, $t0,$t1,$t2,$t3,$t4 onto stack
		addi $sp,$sp,-4
		sw $ra,0($sp)
		addi $sp,$sp,-4
		sw $t0,0($sp)
		addi $sp,$sp,-4
		sw $t1,0($sp)
		addi $sp,$sp,-4
		sw $t2,0($sp)
		addi $sp,$sp,-4
		sw $t3,0($sp)
		
		add $t0,$zero,$zero
		addi $t1,$zero,44
		lw $t2,purple
		la $t3,coolPos
drawCoolLB:		beq $t0,$t1,drawCoolLE
		lw $a0,0($t3)
		lw $a1,4($t3)
		lw $a2,displayAddress
		jal convXY_func
		sw $t2,0($v0)
		addi $t3,$t3,8
		addi $t0,$t0,1
		j drawCoolLB
		# pull $t3,$t2,$t1,$t0,$ra off stack
drawCoolLE:		lw $t3,0($sp)
		addi $sp,$sp,4
		lw $t2,0($sp)
		addi $sp,$sp,4
		lw $t1,0($sp)
		addi $sp,$sp,4
		lw $t0,0($sp)
		addi $sp,$sp,4
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draws the word "NICE!"
draw_nice:		# push $ra, $t0,$t1,$t2,$t3,$t4 onto stack
		addi $sp,$sp,-4
		sw $ra,0($sp)
		addi $sp,$sp,-4
		sw $t0,0($sp)
		addi $sp,$sp,-4
		sw $t1,0($sp)
		addi $sp,$sp,-4
		sw $t2,0($sp)
		addi $sp,$sp,-4
		sw $t3,0($sp)
		
		add $t0,$zero,$zero
		addi $t1,$zero,41
		lw $t2,purple
		la $t3,nicePos
drawNiceLB:		beq $t0,$t1,drawNiceLE
		lw $a0,0($t3)
		lw $a1,4($t3)
		lw $a2,displayAddress
		jal convXY_func
		sw $t2,0($v0)
		addi $t3,$t3,8
		addi $t0,$t0,1
		j drawNiceLB
		# pull $t3,$t2,$t1,$t0,$ra off stack
drawNiceLE:		lw $t3,0($sp)
		addi $sp,$sp,4
		lw $t2,0($sp)
		addi $sp,$sp,4
		lw $t1,0($sp)
		addi $sp,$sp,4
		lw $t0,0($sp)
		addi $sp,$sp,4
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draws the word "GOOD!"
draw_good:		# push $ra, $t0,$t1,$t2,$t3,$t4 onto stack
		addi $sp,$sp,-4
		sw $ra,0($sp)
		addi $sp,$sp,-4
		sw $t0,0($sp)
		addi $sp,$sp,-4
		sw $t1,0($sp)
		addi $sp,$sp,-4
		sw $t2,0($sp)
		addi $sp,$sp,-4
		sw $t3,0($sp)
		
		add $t0,$zero,$zero
		addi $t1,$zero,52
		lw $t2,purple
		la $t3,goodPos
drawGoodLB:		beq $t0,$t1,drawGoodLE
		lw $a0,0($t3)
		lw $a1,4($t3)
		lw $a2,displayAddress
		jal convXY_func
		sw $t2,0($v0)
		addi $t3,$t3,8
		addi $t0,$t0,1
		j drawGoodLB
		# pull $t3,$t2,$t1,$t0,$ra off stack
drawGoodLE:		lw $t3,0($sp)
		addi $sp,$sp,4
		lw $t2,0($sp)
		addi $sp,$sp,4
		lw $t1,0($sp)
		addi $sp,$sp,4
		lw $t0,0($sp)
		addi $sp,$sp,4
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
