# This is where I test MIPS concepts with which I have little confidence
.data
	num: .word 34
	fry: .word 1
	purple: .word 0x8e44ad
	black: .word 0x17202a
	yellow: .word 0xf7dc6f
	displayAddress: .word 0x10008000
	
	
	
.text
	li $a0,16		
	li $a1,25		
	lw $a2,purple	
	lw $a3, displayAddress
	jal draw_doodler_func
EXIT: 	li $v0, 10
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

#Behaviour: Draws the doodler given the location of the doodler's uppermost block in (x,y) coordinates
draw_doodler_func:	addi $sp,$sp,-4	#$a0 = x-value	$a2 = color  	   
		sw $ra,0($sp)	#$a1 = y-value	$a3 = base address -> bitmap or buffer
		add $t5,$zero,$a2	#store color in a temp variable, since convXY requires address as $a2
		add $a2,$zero,$a3	#store address in $a2
		jal convXY_func
		add $a2,$zero,$t5	#restore color to $a2
		sw $a2,0($v0)	
		addi $v0, $v0, 124	
		sw $a2,0($v0)	
		addi $v0, $v0, 4
		sw $a2,0($v0)
		addi $v0, $v0, 4
		sw $a2,0($v0)
		addi $v0, $v0, 120
		sw $a2,0($v0)
		addi $v0, $v0, 8
		sw $a2,0($v0)
		
		lw $ra,0($sp)	#pop off stack
		addi $sp,$sp,4	#move stack pointer back down
		jr $ra
