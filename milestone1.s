#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Student: Peter Sellars, Student Number: 1006389926
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data

	red: .word 0xe74c3c
	skyBlue: .word 0xaed6f1
	green: .word 0x2ecc71
	displayAddress: .word 0x10008000	#upper left unit of bitmap display
	bufferAddress: .word 0x10009000	#upper left unit of buffer 
	doodler_location: .word 0x10008cc0	#must be a multiple of 4, refers to uppermost block of doodler
	doodler_x: .word 16		#doodler's x coordinate
	doodler_y: .word 25		#doodler's y coordinate
	up_momentum: .word 0		#by default this is 0 (i.e. the doodler falls down)
				#is greater than 0 after doodler lands on platform
				#if non-zero and doodler is above a certain y, platforms move down
	
.text
	lw $s0, displayAddress	#$s0 = base address of bitmap display
	lw $s1, red		#$s1 = red colour of doodler
	lw $s2, skyBlue	#$s2 = blue colour of sky
	lw $s3, green	#$s3 = green color of regular platforms
	
	# HOME SCREEN	#set background color, platforms and doodler
	add $t0, $zero, $zero	#i=0 (background color loop)
	addi $t1, $zero, 1024	#32x32 display 
HSL_BEGIN:	beq $t0, $t1, HSL_END	#end loop when all units have been iterated over
	sw $s2, 0($s0)
	addi $s0, $s0, 4
	addi $t0, $t0, 1
	j HSL_BEGIN	
HSL_END:	lw $s0, displayAddress	#reset $s0 to store displayAddress again

	li $a0, 268471988	#draw base platform
	add $a1, $zero, $s3
	jal draw_regplat_function
	
	li $a0, 268470860	#draw base platform 2
	add $a1, $zero, $s3
	jal draw_regplat_function
	
	li $a0, 268469908	#draw base platform 3
	add $a1, $zero, $s3
	jal draw_regplat_function
	
	lw $a0,doodler_x	#draw doodler
	lw $a1,doodler_y
	lw $a2,red	
	jal draw_doodler_function
	
GL_BEGIN:	
	la $t0,doodler_y
	lw $t1,doodler_y
	addi $t1,$t1,-1
	sw $t1, 0($t0)
	lw $a0,doodler_x
	lw $a1,doodler_y
	lw $a2,red
	jal draw_doodler_function
	li $v0, 32		#sleep for 100 ms
	li $a0, 100
	syscall
	j GL_BEGIN
	
GL_END:	li $v0 10
	syscall	

# FUNCTIONS

#Behaviour: Draws the doodler given the location of the doodler's uppermost block in (x,y) coordinates
draw_doodler_function:	lw $t0, displayAddress	#a0 = x-value
		add $t1,$zero,$zero	#a1 = y-value
		add $t2, $zero,$zero	#a2 = red
DDRXL_BEGIN:		beq $t1,$a0,DDRXL_END
		addi $t0,$t0,4
		addi $t1, $t1,1
		j DDRXL_BEGIN
DDRXL_END:		beq $t2, $a1,DDRYL_END
		addi $t0,$t0,128
		addi $t2, $t2,1
		j DDRXL_END
DDRYL_END:		sw $a2,0($t0)	
		addi $t0, $t0, 124	
		sw $a2,0($t0)	
		addi $t0, $t0, 4
		sw $a2,0($t0)
		addi $t0, $t0, 4
		sw $a2,0($t0)
		addi $t0, $t0, 120
		sw $a2,0($t0)
		addi $t0, $t0, 8
		sw $a2,0($t0)
		
		jr $ra

#Behaviour: Draws a normal platform given the location of the platform's leftmost block	
draw_regplat_function:	addi $t0,$zero,0	#$a0 = location of platform's leftmost block
		addi $t1, $zero,7	#$a1 = green
DRPL_BEGIN:		beq $t0,$t1, DRPL_END
		sw $a1, 0($a0)
		addi $t0, $t0, 1
		addi $a0, $a0, 4
		j DRPL_BEGIN
		
DRPL_END:		jr $ra
				
#Behaviour: Draws the contents of the buffer on the bitmap display
draw_bitmap_function:	addi $t0,$zero,0	#$t0 = 0 (loop counter)
		addi $t1,$zero,1024	#$t1 = 1024 (loop limit)
		la $t2,displayAddress	#$t2 = display address
		la $t3,bufferAddress	#$t3 = buffer address
		lw $t4,bufferAddress	#$t4 = contents of buffer address
DBL_BEGIN:		beq $t0,$t1,DBL_END
		sw $t4, 0($t2)	#store contents of buffer in corresponding display slot
		addi $t3,$t3,4	#move buffer address to next slot
		lw $t4,0($t3)	#update $t4 with contents of next buffer slot
		addi $t0,$t0,1	#increment counter
		j DBL_BEGIN		#loop

DBL_END:		jr $ra













