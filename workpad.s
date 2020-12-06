# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	fry: .word 1
	purple: .word 0x8e44ad
	black: .word 0x17202a
	yellow: .word 0xf7dc6f
	displayAddress: .word 0x10008000
	
	
	
.text
	li $a0,0
	li $a1,27
	lw $a2,displayAddress
	jal draw_zero
	li $a0,4
	li $a1,27
	lw $a2,displayAddress
	jal draw_eight
	li $a0,8
	li $a1,27
	lw $a2, displayAddress
	jal draw_nine
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
	

			
# Behaviour: Draw the number 0
draw_zero:		#$a0 = x, $a1 = y, $a2 = base address
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,8
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,8
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,8
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,8
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
# Behaviour: draw the number one
draw_one:		#$a0 = x-value, $a1 = y-value, $a2 = base address
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		addi $v0,$v0,8
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draw the number two
draw_two: 		#$a0 = x-value, $a1 = y-value, $a2 = base address
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra

# Behaviour: draw the number three
draw_three:		#$a0 = x-value, $a1 = y-value, $a2 = displayAddress
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,136
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draw the number four
draw_four:		#$a0 = x-value, $a1 = y-value, $a2 = base address
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		sw $t0,0($v0)
		addi $v0,$v0,8
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,8
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra

# Behaviour: draw the number five
draw_five:		#$a0 = x-value, $a1 = y-value, $a2 = base address
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draws the number six
draw_six:		#$a0 = x-value, $a1 = y-value, $a2 = base address
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,-128
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draw the number seven
draw_seven:		#$a0 = x-value, $a1 = y-value, $a2 = base address
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draw the number eight
draw_eight:		#$a0 = x-value, $a1 = y-value, $a2 = base address
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,-4
		sw $t0,0($v0)
		addi $v0,$v0,-128
		sw $t0,0($v0)
		addi $v0,$v0,-248
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draw the number nine
draw_nine:		#$a0 = x-value, $a1 = y-value, $a2 = base address
		addi $sp,$sp,-4
		sw $ra,0($sp)
		jal convXY_func
		lw $t0,yellow
		sw $t0,0($v0)
		addi $v0,$v0,8
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,8
		sw $t0,0($v0)
		addi $v0,$v0,120
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,4
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,128
		sw $t0,0($v0)
		addi $v0,$v0,-516
		sw $t0,0($v0)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra