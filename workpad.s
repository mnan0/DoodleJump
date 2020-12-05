# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	fry: .word 1
	purple: .word 0x8e44ad
	black: .word 0x17202a
	displayAddress: .word 0x10008000
	ggPos: .word 11,8,12,8,13,8,14,8,11,9,11,10,11,11,11,12,12,12,13,12,14,12,14,11,14,10,13,10,
	18,8,19,8,20,8,21,8,18,9,18,10,18,11,18,12,19,12,20,12,21,12,21,11,21,10,20,10,
	16,12,23,12
	rPlayPos: .word 2,21,2,22,2,23,3,21,4,21,
	7,21,8,21,9,21,8,20,8,22,8,23,
	11,21,12,21,13,21,11,22,13,22,11,23,13,23,12,23,
	16,20,17,20,18,20,18,21,18,22,17,22,16,22,16,21,16,23,16,24,
	20,20,20,21,20,22,20,23,20,24,21,24,22,24,
	24,20,25,20,26,20,24,21,26,21,24,22,25,22,26,22,24,23,24,24,26,23,26,24,
	28,20,28,21,28,22,29,22,30,22,30,21,30,20,29,23,29,24
	
	
.text
	jal draw_gg
EXIT: 	li $v0 10
	syscall
# Behaviour: Converts (x,y) into hexadecimal, given a base address (buffer or bitmap)
convXY_func:		add $t0,$zero,$a2	#a0 = x-value
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
		jr $ra
		
# Behaviour: Write GG on the screen, r to play
draw_gg:		la $t7,ggPos
		add $t5,$zero,$zero
		addi $t6,$zero,32
		addi $sp,$sp,-4
		sw $ra,0($sp)
drawGGL:		beq $t5,$t6,drawGGdone
		lw $a0,0($t7)
		lw $a1,4($t7)
		lw $a2,displayAddress
		jal convXY_func
		lw $t0,purple
		sw $t0,0($v0)
		addi $t7,$t7,8
		addi $t5,$t5,1
		j drawGGL
drawGGdone:		add $t5,$zero,$zero
		la $t7,rPlayPos
		addi $t6,$zero,57
drawRPlay:		beq $t5,$t6,drawRPlaydone
		lw $a0,0($t7)
		lw $a1,4($t7)
		lw $a2,displayAddress
		jal convXY_func
		lw $t0,purple
		sw $t0,0($v0)
		addi $t7,$t7,8
		addi $t5,$t5,1
		j drawRPlay
drawRPlaydone:	lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra

