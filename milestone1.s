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

	displayAddress: .word 0x10008000	#upper left unit of bitmap display
	bufferAddress: .word 0x10009000	#upper left unit of buffer 
	doodler_location: .word 0x10008cc0	#must be a multiple of 4, refers to uppermost block of doodler
	orange: .word 0xf39c12
	skyBlue: .word 0xaed6f1
	green: .word 0x2ecc71
.text
	lw $s0, displayAddress	#$s0 = base address of bitmap display
	lw $s1, orange	#$s1 = orange colour of doodler
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

	li $a0, 0x10008eb4
	add $a1, $zero, $s3
	jal draw_regplat_function
	
	lw $a0,doodler_location	#a0 = doodler's base location
	add $a1,$zero,$s1	#a1 = orange
	jal draw_doodler_function
EXIT:	li $v0 10
	syscall	

# FUNCTIONS

#Behaviour: Draws the doodler given the location of the doodler's uppermost block
draw_doodler_function:	add $t0,$zero,$a0	#a0 = location of doodler's uppermost block
		sw $a1,0($t0)	#a1 = orange
		addi $t0, $t0, 124	
		sw $a1,0($t0)	
		addi $t0, $t0, 4
		sw $a1,0($t0)
		addi $t0, $t0, 4
		sw $a1,0($t0)
		addi $t0, $t0, 120
		sw $a1,0($t0)
		addi $t0, $t0, 8
		sw $a1,0($t0)
		
		jr $ra

#Behaviour: Draws a normal platform given the location of the platform's leftmost block	
draw_regplat_function:	addi $t0,$zero,0	#$a0 = location of platform's leftmost block
		addi $t1, $zero,7	#$a1 = green
DRL_BEGIN:		beq $t0,$t1, DRL_END
		sw $a1, 0($a0)
		addi $t0, $t0, 1
		addi $a0, $a0, 4
		j DRL_BEGIN
DRL_END:		jr $ra
				















