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
	doodler_y: .word 25		#doodler's y coordinate (REMEMBER +Y is lower on display!)
	up_momentum: .word 0		#by default this is 0 (i.e. the doodler falls down)
				#is greater than 0 after doodler lands on platform
				#if non-zero and doodler is above a certain y, platforms move down
	platforms: .space 24		#6 slots for 3 platforms (x,y)
	up_threshold: .word 14		#when doodler_y == up_threshold && up_momentum > 0, move platforms
				#down instead of moving doodler up
	
.text
	lw $s0, displayAddress	#$s0 = base address of bitmap display
	lw $s1, red		#$s1 = red colour of doodler
	lw $s2, skyBlue	#$s2 = blue colour of sky
	lw $s3, green	#$s3 = green color of regular platforms
	lw $s4, bufferAddress	#$s4 = base address of buffer display
	
	# HOME SCREEN	#set background color, platforms and doodler
	add $t0, $zero, $zero	#i=0 (background color loop)
	addi $t1, $zero, 1024	#32x32 display 
HSL_BEGIN:	beq $t0, $t1, HSL_END	#end loop when all units have been iterated over
	sw $s2, 0($s4)
	addi $s4, $s4, 4
	addi $t0, $t0, 1
	j HSL_BEGIN	
HSL_END:	lw $s4, bufferAddress	#reset $s0 to store bufferAddress again

	li $a0, 268476084	#draw base platform
	#li $a0, 268471988
	add $a1, $zero, $s3
	jal draw_regplat_function
	
	li $a0, 268474956	#draw base platform 2
	#li $a0, 268470860
	add $a1, $zero, $s3
	jal draw_regplat_function
	
	li $a0, 268474004	#draw base platform 3
	#li $a0, 268469908
	add $a1, $zero, $s3
	jal draw_regplat_function
	
	lw $a0,doodler_x	#draw doodler
	lw $a1,doodler_y
	lw $a2,red	
	lw $a3,bufferAddress 
	jal draw_doodler_function
	jal draw_bitmap_function
GL_BEGIN:	# GAME LOOP		
	#lw $t0,up_momentum	#$t0 = up_momentum
	#la $t1,up_momentum	#$t1 = mem address of up_momentum
	#beq $t0,$zero,FALL_DOWN	#if up_momentum is zero, fall down and check for collision
	#addi $t0,$t0,-1	#else,decrement up_momentum and move doodler up
	#sw $t0,0($t1)	#decrement up_momentum and store it
	#lw $t0,doodler_y	#increment doodler's y-value
	#la $t1,doodler_y
	#addi $t0,$t0,-1	#a lower y-value means a higher row on the display
	#sw $t0,0($t1)
	#j UP_MOM_END		#skip the else block (FALL_DOWN)
		
FALL_DOWN:#	lw $t0,doodler_y
	#la $t1,doodler_y
	#addi $t0,$t0,1	#a higher y-value means a lower row on the display

UP_MOM_END:
	# LAST PART OF GL --> sleep	
	li $v0, 32		
	li $a0, 100
	syscall
	# Draw blue at location of doodler and platforms
	lw $a0,doodler_x
	lw $a1,doodler_y
	lw $a2,skyBlue
	lw $a3,bufferAddress
	jal draw_doodler_function
	lw $t0,doodler_y
	la $t1,doodler_y
	addi $t0,$t0,-1
	sw $t0,0($t1)
	lw $a0,doodler_x
	lw $a1,doodler_y
	lw $a2,red
	lw $a3, bufferAddress
	jal draw_doodler_function
	jal draw_bitmap_function
	j GL_BEGIN
	
GL_END:	li $v0, 10
	syscall	

# FUNCTIONS

#Behaviour: Draws the doodler given the location of the doodler's uppermost block in (x,y) coordinates
draw_doodler_function:	add $t0,$zero,$a3	#a0 = x-value
		add $t1,$zero,$zero	#a1 = y-value
		add $t2, $zero,$zero	#a2 = color
DDRXL_BEGIN:		beq $t1,$a0,DDRXL_END	#a3 = address
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
		addi $t1, $zero,7	#$a1 = color
DRPL_BEGIN:		beq $t0,$t1, DRPL_END
		sw $a1, 0($a0)
		addi $t0, $t0, 1
		addi $a0, $a0, 4
		j DRPL_BEGIN
		
DRPL_END:		jr $ra
				
#Behaviour: Draws the contents of the buffer on the bitmap display
draw_bitmap_function:	addi $t0,$zero,0	#$t0 = 0 (loop counter)
		addi $t1,$zero,1024	#$t1 = 1024 (loop limit)
		lw $t2,displayAddress	#$t2 = display address
		lw $t3,bufferAddress	#$t3 = buffer address
		lw $t4,0($t3)	#$t4 = contents of buffer address
		
DBL_BEGIN:		beq $t0,$t1,DBL_END
		sw $t4, 0($t2)	#store contents of buffer in corresponding display slot
		addi $t2, $t2, 4
		addi $t3,$t3,4	#move buffer address to next slot
		lw $t4,0($t3)	#update $t4 with contents of next buffer slot
		addi $t0,$t0,1	#increment counter
		j DBL_BEGIN		#loop

DBL_END:		jr $ra













