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
	purple: .word 0x5b2c6f
	yellow: .word 0xf7dc6f
	stoneGrey: .word 0x85929e
	white: .word 0xfdfefe
	black: .word 0x1c2833
	displayAddress: .word 0x10008000	#upper left unit of bitmap display
	bufferAddress: .word 0x10009000	#upper left unit of buffer 
	doodler_location: .word 0x10008cc0	#must be a multiple of 4, refers to uppermost block of doodler
	doodler_x: .word 16		#doodler's x coordinate
	doodler_y: .word 25		#doodler's y coordinate (REMEMBER +Y is lower on display!)
				# 0 <= x <= 31
				# 0 <= y <= 31
	up_momentum: .word 0		#by default this is 0 (i.e. the doodler falls down)
				#is greater than 0 after doodler lands on platform
				#if non-zero and doodler is above a certain y, platforms move down
	#down_momentum: .word 0
	normPlat_xy: .word 13,29,5,9,19,19,0,0		#8 slots for 4 platforms (x,y)
	normPlat_hex: .word 0:28		#28 slots for 4 platforms' hexadecimal locations (on buffer)
				#platforms are numbered 0 -> 3
	up_threshold: .word 7		#when doodler_y == up_threshold && up_momentum > 0, move platforms
				#down instead of moving doodler up
	scoreHund: .word 0		#the player's score can go up to 999
	scoreTens: .word 0
	scoreOnes: .word 0 
	#acceleration: .word 3		#magnitude of acceleration
	spring_exists: .word 0 
	spring_xy: .word 0,0
	spring_hex: .word 0,0,0		#spring is 3x1 rectangle
	rocket_exists: .word 0
	rocket_enabled: .word 0
	# rocket has 24 units
	# top 19 are white, bottom 5 are black
	rocket_hex: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	rocket_centre: .word 0		# quick reference to doodler tip	
	ggPos: .word 11,2,12,2,13,2,14,2,11,3,11,4,11,5,11,6,12,6,13,6,14,6,14,5,14,4,13,4,
	18,2,19,2,20,2,21,2,18,3,18,4,18,5,18,6,19,6,20,6,21,6,21,5,21,4,20,4,
	16,6,23,6
	rPlayPos: .word 2,21,2,22,2,23,3,21,4,21,
	7,21,8,21,9,21,8,20,8,22,8,23,
	11,21,12,21,13,21,11,22,13,22,11,23,13,23,12,23,
	16,20,17,20,18,20,18,21,18,22,17,22,16,22,16,21,16,23,16,24,
	20,20,20,21,20,22,20,23,20,24,21,24,22,24,
	24,20,25,20,26,20,24,21,26,21,24,22,25,22,26,22,24,23,24,24,26,23,26,24,
	28,20,28,21,28,22,29,22,30,22,30,21,30,20,29,23,29,24
	cStopPos: .word 2,27,2,28,2,29,3,27,4,27,3,29,4,29,
	7,27,8,27,9,27,8,26,8,28,8,29,
	11,27,12,27,13,27,11,28,13,28,11,29,13,29,12,29,
	16,26,17,26,18,26,16,27,16,28,17,28,18,28,18,29,18,30,17,30,16,30,
	20,26,21,26,22,26,21,27,21,28,21,29,21,30,
	24,26,25,26,26,26,26,27,26,28,26,29,26,30,25,30,24,30,24,29,24,28,24,27,
	28,26,29,26,30,26,30,27,30,28,29,28,28,28,28,27,28,29,28,30
	
	
.text
	j BEGIN
RESTART:	# overwrite doodler's and normPlats' xy with original values
	la $t0,doodler_x	
	li $t1,16
	sw $t1,0($t0)
	la $t0,doodler_y
	li $t1,25
	sw $t1,0($t0)
	la $t0,normPlat_xy
	li $t1,13
	sw $t1,0($t0)
	addi $t0,$t0,4 
	li $t1,29
	sw $t1,0($t0)
	addi $t0,$t0,4
	li $t1,5
	sw $t1,0($t0)
	addi $t0,$t0,4
	li $t1,9
	sw $t1,0($t0)
	addi $t0,$t0,4
	li $t1,19
	sw $t1,0($t0)
	addi $t0,$t0,4
	li $t1,19
	sw $t1,0($t0)
	la $t0,scoreHund
	sw $zero,0($t0)
	la $t0,scoreTens
	sw $zero,0($t0)
	la $t0,scoreOnes
	sw $zero,0($t0)
	la $t0,spring_exists
	sw $zero,0($t0)
	la $t0,spring_hex
	sw $zero,0($t0)
	sw $zero,4($t0)
	sw $zero,8($t0)
	# add reset for rocket here!!!!!
	
BEGIN:	lw $s0, displayAddress	#$s0 = base address of bitmap display
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
HSL_END:	lw $s4, bufferAddress	#reset $s4 to store bufferAddress again

	li $a0, 13		#draw base platform
	li $a1, 29
	#li $a0, 268471988
	add $a2, $zero, $s3
	add $a3,$zero,$zero
	jal draw_regplat_func
	
	li $a0, 5		#draw base platform 2
	li $a1, 9
	#li $a0, 268470860
	add $a2, $zero, $s3
	addi $a3,$zero,1
	jal draw_regplat_func
	
	li $a0, 19		#draw base platform 3
	li $a1, 19
	#li $a0, 268469908
	add $a2, $zero, $s3
	addi $a3,$zero,2
	jal draw_regplat_func
	
	lw $a0,doodler_x	#draw doodler
	lw $a1,doodler_y
	lw $a2,red	
	lw $a3,bufferAddress 
	jal draw_doodler_func
	jal draw_bitmap_func
	
GL_BEGIN:	# GAME LOOP	
	#sleep	
	li $v0, 32		
	li $a0, 50
	syscall	
	# Draw blue at location of doodler and platforms and spring	
	lw $a0,doodler_x
	lw $a1,doodler_y
	lw $a2,skyBlue
	lw $a3,bufferAddress
	jal draw_doodler_func
	lw $t0,rocket_exists
	beq $t0,0,checkSpringBlue
	li $a0,0
	jal draw_rocket
checkSpringBlue:	lw $t0,spring_exists
	beq $t0,0,noOWSpring
	lw $a0,skyBlue
	jal draw_spring
noOWSpring:	la $t0,normPlat_xy
	lw $a0,0($t0)
	lw $a1,4($t0)
	lw $a2,skyBlue
	add $a3,$zero,$zero
	jal draw_regplat_func
	la $t0,normPlat_xy
	lw $a0,8($t0)
	lw $a1,12($t0)
	lw $a2,skyBlue
	addi $a3,$zero,1
	jal draw_regplat_func
	la $t0,normPlat_xy
	lw $a0,16($t0)
	lw $a1,20($t0)
	lw $a2,skyBlue
	addi $a3,$zero,2
	jal draw_regplat_func
	add $t0,$zero,$zero
	addi $t1,$zero,11
	addi $t2,$zero,0x10009d80
	addi $t3,$zero,0x10009e00
	addi $t4,$zero,0x10009e80
	addi $t5,$zero,0x10009f00
	addi $t6,$zero,0x10009f80
	#add $t7,$zero,$zero
	lw $t8,skyBlue
	
sEraseBeg:	beq $t0,$t1,scoreEraseEnd
	sw $t8,0($t2)
	sw $t8,0($t3)
	sw $t8,0($t4)
	sw $t8,0($t5)
	sw $t8,0($t6)
	addi $t2,$t2,4
	addi $t3,$t3,4
	addi $t4,$t4,4
	addi $t5,$t5,4
	addi $t6,$t6,4
	addi $t0,$t0,1
	j sEraseBeg
	
	# Check for keyboard input
scoreEraseEnd:	lw $t0,0xffff0000
	beq $t0,1,key_input
	j no_key_input
key_input:	lw $t1,0xffff0004
	lw $t0,rocket_enabled
	beq $t0,1,no_key_input
	beq $t1,0x6a,move_left
	beq $t1,0x6b,move_right
	beq $t1,0x63,endgame
	j no_key_input
move_left:	lw $t0,doodler_x
	la $t1,doodler_x
	beq $t0,1,no_key_input		#prevent move left if at edge
	addi $t0,$t0,-1
	sw $t0,0($t1)
	j no_key_input
move_right:	lw $t0,doodler_x
	la $t1,doodler_x
	beq $t0,30,no_key_input		#prevent move right if at edge
	addi $t0,$t0,1
	sw $t0,0($t1)
	j no_key_input
endgame:	# show gameover
	
	add $t0,$zero,$zero
	addi $t1,$zero,1024
	lw $t2,skyBlue
shutLBeg:	beq $t0,$t1,shutLend
	addi $t0,$t0,1
	sw $t2,0($s0)
	addi $s0,$s0,4
	j shutLBeg
shutLend:
	jal draw_EndScore
	jal draw_gg
shutCollect:	lw $t0,0xffff0000
	beq $t0,1,shutInput
	li $v0,32
	li $a0,100
	syscall
	j shutCollect
shutInput:	lw $t1,0xffff0004
	beq $t1,0x72,RESTART
	beq $t1,0x63,GL_END
	j shutCollect
no_key_input: 	# if rocket_exists == 1 && rocket_enabled == 0, check for doodler touching rocket
		# if doodler touches rocket, set up_momentum == 64, set rocket_enabled == 1, set xy to rocket_centre
		lw $t0,rocket_exists
		beq $t0,0,noAstronaut
		lw $t0,rocket_enabled
		beq $t0,1,noAstronaut
		jal check_touch_rocket
		beq $v0,0,noAstronaut
		la $t0,up_momentum
		li $t1,64
		sw $t1,0($t0)
		la $t0,rocket_enabled
		li $t1,1
		sw $t1,0($t0)
		# set doodler_x and doodler_y to centre of rocket ship
		la $t0,rocket_hex
		lw $t1,24($t0)
		add $a0,$zero,$t1
		lw $a1,bufferAddress
		jal convHex_func
		la $t0,doodler_x
		la $t1,doodler_y
		sw $v0,0($t0)
		sw $v1,0($t1)
		j DRAW_STUFF
noAstronaut:		lw $t0,up_momentum	#$t0 = up_momentum
		la $t1,up_momentum	#$t1 = mem address of up_momentum
		
		beq $t0,$zero,FALL_DOWN	#if up_momentum is zero, fall down and check for collision
		lw $t2,up_threshold
		lw $t3,doodler_y
		addi $t0,$t0,-1	#else,decrement up_momentum and move doodler up
		sw $t0,0($t1)	#decrement up_momentum and store it
		bge $t2,$t3,PLAT_DOWN	#if up_momentum > 0 and doodler is at threshold, move platforms down
		
		lw $t0,doodler_y	#decrement doodler's y-value
		la $t1,doodler_y
		addi $t0,$t0,-1	#a lower y-value means a higher row on the display
		sw $t0,0($t1)
		
		# if rocket_enabled == 1, then move rocket_hex up as well
		lw $t0,rocket_enabled
		beq $t0,0,DRAW_STUFF
		li $t0,0
		li $t1,24
		la $t2,rocket_hex
rocketUpBeg:		beq $t0,$t1,rocketUpEnd
		lw $t3,0($t2)
		addi $t3,$t3,-128
		sw $t3,0($t2)
		addi $t2,$t2,4
		addi $t0,$t0,1
		j rocketUpBeg
rocketUpEnd:
		j DRAW_STUFF		#skip the else block (FALL_DOWN)
		
FALL_DOWN:	lw $t0,doodler_y
	la $t1,doodler_y
	addi $t0,$t0,1	#a higher y-value means a lower row on the display
	sw $t0,0($t1)
	lw $a0, doodler_x
	lw $a1, doodler_y
	jal regPlatDet_func
	# increase down_momentum
	# increase acceleration
	beq $v0,1,ADD_REG_MOM	#if standing on platform, add momentum
	# if rocket_exists == 1 && rocket_enabled == 1 then set both to 0
	lw $t0,rocket_exists
	lw $t1,rocket_enabled
	beq $t0,0,checkSprDetF
	beq $t1,0,checkSprDetF
	la $t0,rocket_exists
	la $t1,rocket_enabled
	sw $zero,0($t0)
	sw $zero,0($t1)
checkSprDetF:	lw $a0, doodler_x
	lw $a1, doodler_y
	jal regSpringDet_func
	beq $v0,1,ADD_SPRING_MOM
	beq $v0,0,DRAW_STUFF	#if not standing on platform,draw at one unit lower than before
ADD_REG_MOM:
	lw $t0,up_momentum
	la $t1,up_momentum
	addi $t0,$t0,15
	sw $t0,0($t1)
	j DRAW_STUFF
ADD_SPRING_MOM:	lw $t0,up_momentum
		la $t1,up_momentum
		addi $t0,$t0,32
		sw $t0,0($t1)
		j DRAW_STUFF
PLAT_DOWN:	# move all platforms down one unit. If platform is at bottom of display (y=31),move to top
	# of display and randomize x-value
	# every time platforms move down, add one to the score
	jal move_plats_down
	jal addOnePt
DRAW_STUFF:
	la $t0,normPlat_xy
	lw $a0,0($t0)
	lw $a1,4($t0)
	lw $a2,green
	add $a3,$zero,$zero
	jal draw_regplat_func
	la $t0,normPlat_xy
	lw $a0,8($t0)
	lw $a1,12($t0)
	lw $a2,green
	addi $a3,$zero,1
	jal draw_regplat_func
	la $t0,normPlat_xy
	lw $a0,16($t0)
	lw $a1,20($t0)
	lw $a2,green
	addi $a3,$zero,2
	jal draw_regplat_func
	lw $t0,rocket_exists
	beq $t0,0,checkSpringDrawReg
	li $a0,1
	jal draw_rocket
checkSpringDrawReg:
	lw $t0,spring_exists
	beq $t0,0,dontDrawSpring
	lw $a0,stoneGrey
	jal draw_spring
dontDrawSpring:	
	lw $a0,doodler_x
	lw $a1,doodler_y
	lw $a2,red
	lw $a3, bufferAddress
	jal draw_doodler_func
	li $a0,0
	li $a1,27
	lw $a2,bufferAddress
	lw $a3,scoreHund
	jal draw_SNum
	li $a0,4
	li $a1,27
	lw $a2,bufferAddress
	lw $a3,scoreTens
	jal draw_SNum
	li $a0,8
	li $a1,27
	lw $a2,bufferAddress
	lw $a3,scoreOnes
	jal draw_SNum
	jal draw_bitmap_func
	lw $t0,doodler_y
	beq $t0,29,endgame
	j GL_BEGIN
	
GL_END:	li $v0, 10
	syscall	

# FUNCTIONS

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

#Behaviour: Draws a normal platform (on the buffer) given the location of the platform's leftmost block	
draw_regplat_func:			#$a0 = x-value, $a1 = y-value, $a2 = color,$a3 = identity
		addi $sp,$sp,-4	#prepare stack pointer for pushing
		sw $ra,0($sp)	#push $ra onto stack
				
		add $t5,$zero,$a2	#store color in temporary variable
		lw $a2,bufferAddress
		jal convXY_func
		addi $t0,$zero,0	#count
		addi $t1, $zero,7	#loop limit
		add $a2,$zero,$t5	#restore color to $a2
		la $t2,normPlat_hex	#load address of normal platforms' hex array
DRID_BEGIN:		beq $t0,$a3,DRID_END	
		addi $t2,$t2,28	#determine offset for updating hex values
		addi $t0,$t0,1
		j DRID_BEGIN
DRID_END:		add $t0,$zero,$zero	#count
DRPL_BEGIN:		beq $t0,$t1, DRPL_END	
		sw $a2, 0($v0)
		sw $v0, 0($t2)
		addi $t0, $t0, 1
		addi $v0, $v0, 4
		addi $t2,$t2,4
		j DRPL_BEGIN
		
DRPL_END:		lw $ra,0($sp)	#pop original $ra
		addi $sp,$sp,4	#restore stack pointer
		jr $ra		#return no values
				
#Behaviour: Draws the contents of the buffer on the bitmap display
draw_bitmap_func:	addi $t0,$zero,0	#$t0 = 0 (loop counter)
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

# Behaviour: Draws a spring (assume spring_exists == 1)
# $a0 = colour
draw_spring:		
		lw $t1,spring_hex
		sw $a0,0($t1)
		sw $a0,4($t1)
		sw $a0,8($t1)
		jr $ra 

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
# Behaviour: convert hexadecimal to xy coordinates
# $a0 = hex
# $a1 = base hex address (bitmap or buffer)	
convHex_func:	sub $t0,$a0,$a1
		add $t1,$zero,$zero	#x
		add $t2,$zero,$zero	#y
convHexLBeg:		beq $t0,$zero,convHexEnd
		bge $t0,128,convHexAddY
		add $t1,$t1,1
		sub $t0,$t0,4
		j convHexLBeg
convHexAddY:		add $t2,$t2,1
		sub $t0,$t0,128
		j convHexLBeg	
convHexEnd:		add $v0,$zero,$t1
		add $v1,$zero,$t2
		jr $ra
# Behaviour: Given doodler's x and y, determine if doodler is on top of a regular platform
# $a0 = x-value	$a1 = y-value
regPlatDet_func:	addi $sp,$sp,-4	
		sw $ra,0($sp)	#push $ra on stack, since nested call occurring
		lw $a2,bufferAddress	
		jal convXY_func
		addi $t0,$v0,-4
		addi $t1,$v0,4
		addi $t0,$t0,384	#$t0 = unit on buffer directly below doodler's left foot
		addi $t1,$t1,384	#$t1 = unit on buffer directly below doodler's right foot
		add $t5,$zero,$zero	#loop counter
		addi $t6,$zero,28	#loop limit
		lw $ra,0($sp)	#restore $ra
		addi $sp,$sp,4
		la $t2,normPlat_hex	#array memory address
		lw $t3,0($t2)	#contents of first element in array
RPDL_BEGIN:		beq $t5,$t6,RPD_NO	#loop over hex addresses of platforms
		beq $t0,$t3,RPD_YES	#if doodler is standing on platform, return yes
		beq $t1,$t3,RPD_YES
		addi $t2,$t2,4	#move to next address of hex address
		lw $t3,0($t2)	#update contents of hex address variable
		addi $t5,$t5,1
		j RPDL_BEGIN
RPD_NO:		li $v0,0		#return 0 iff doodler is not standing on regular platform
		jr $ra
RPD_YES:		li $v0,1		#return 1 iff doodler is standing on regular platform
		jr $ra		
		
# Behaviour: Given doodler's x and y, checks if doodler is standing on spring
# $a0 = x-value, $a1 = y-value
regSpringDet_func:	addi $sp,$sp,-4
		sw $ra,0($sp)
		lw $a2, bufferAddress
		jal convXY_func
		addi $t0,$v0,-4
		addi $t1,$v0,4
		addi $t0,$t0,384	#$t0 = unit on buffer directly below doodler's left foot
		addi $t1,$t1,384	#$t1 = unit on buffer directly below doodler's right foot
		add $t2,$zero,$zero
		addi $t3,$zero,3
		lw $t4,spring_hex
springDetLBeg:	beq $t2,$t3,springDetNo
		beq $t0,$t4,springDetYes
		beq $t1,$t4,springDetYes
		addi $t4,$t4,4
		addi $t2,$t2,1
		j springDetLBeg
springDetNo:		li $v0,0
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
springDetYes:	li $v0,1
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
# Behaviour: Move all platforms down one unit (changing x and y values, not hexadecimal)
# also moves spring and rocket down
# No drawing is done here
move_plats_down:	
		add $t4,$zero,$zero
		addi $t5,$zero,3
		# push $ra to stack
		addi $sp,$sp,-4
		sw $ra,0($sp)
		# if rocket exists, move it down but first check if it should be erased
		# if rocket doesn't exist, check if spring exists
		# if rocket exists AND enabled, don't move it
		lw $t2,rocket_exists
		beq $t2,0,checkSprExists
		lw $t2,rocket_enabled
		beq $t2,1,checkSprExists
		jal move_rocket_down
		# if spring exists, move it down
		# if spring doesn't exist, move platforms down
checkSprExists:	lw $t2,spring_exists
		beq $t2,0,movePlatBegin
		lw $a0,spring_hex
		# if spring is outside buffer, use special manual method to move down
		# since convHex involves address - buffer, and spring not on buffer implies address < buffer
		blt $a0,0x10009000,springManDown
		lw $a1,bufferAddress
		jal convHex_func
		
		# if spring y == 30, "erase" by setting spring_exists to 0
		# spring_hex still has info, but we won't be reading from it
		# otherwise, move it down
		beq $v1,30,eraseSpring
		addi $a1,$v1,1
		add $a0,$v0,$zero
		lw $a2, bufferAddress
		jal convXY_func
		la $t2,spring_hex
		sw $v0,0($t2)
		addi $v0,$v0,4
		addi $t2,$t2,4
		sw $v0,0($t2)
		addi $v0,$v0,4
		addi $t2,$t2,4
		sw $v0,0($t2)
		la $t0,normPlat_xy
		j movePlatBegin
springManDown:	la $t0,spring_hex
		add $a0,$a0,128
		sw $a0,0($t0)
		add $t0,$t0,4
		lw $a0,0($t0)
		add $a0,$a0,128
		sw $a0,0($t0)
		add $t0,$t0,4
		lw $a0,0($t0)
		add $a0,$a0,128
		sw $a0,0($t0)
		j movePlatBegin
eraseSpring:		la $t2,spring_exists
		sw $zero,0($t2)
		j movePlatBegin
movePlatBegin:	la $t0,normPlat_xy
		addi $t0,$t0,4
movePlatBegL:	beq $t4,$t5,movePlatDone
		lw $t1,0($t0)
		beq $t1,31,PlatToTop
		addi $t1,$t1,1
		sw $t1,0($t0)
		addi $t4,$t4,1
		addi $t0,$t0,8
		j movePlatBegL
PlatToTop:		# $t0 = address of y-value of curr platform
		sw $zero,0($t0)
		# $t6 = address of x-value of curr platform
		addi $t6,$t0,-4
		# generate random x-value for top platform
		li $v0,42
		li $a0,0
		li $a1,25
		syscall
		# store random x-value for top platform
		sw $a0,0($t6)
		# if either a spring or rocket exists, don't generate a new spring
		lw $t7,spring_exists
		beq $t7,1,incPlatLabs
		lw $t7,rocket_exists
		beq $t7,1,incPlatLabs
		# There is an 10% chance of a spring on the next platform
		li $v0,42
		li $a0,0
		li $a1,10
		syscall
		beq $a0,0,setSpringExists
		# There is a 5% chance of a rocket on the next platform
		li $v0,42
		li $a0,0
		li $a1,20
		syscall
		beq $a0,0,setRocketExists
		j incPlatLabs
setSpringExists:	# set spring_exists to 1
		la $t2,spring_exists
		addi $t3,$zero,1
		sw $t3,0($t2)
		# determine offset of spring location from leftmost platform unit
		# push $t4, $t5,$t0 onto stack before convXY_func is called
		addi $sp,$sp,-4
		sw $t4,0($sp)
		addi $sp,$sp,-4
		sw $t5,0($sp)
		addi $sp,$sp,-4
		sw $t0,0($sp)
		lw $a0,0($t6)
		lw $a1,4($t6)
		lw $a2,bufferAddress
		jal convXY_func
		# $t2 = hex
		add $t2,$zero,$v0
		li $v0,42
		li $a0,0
		li $a1,4
		syscall
		add $a1,$zero,$a0
		add $a0,$zero,$t2
		lw $t0,0($sp)
		addi $sp,$sp,4
		lw $t5,0($sp)
		addi $sp,$sp,4
		lw $t4,0($sp)
		addi $sp,$sp,4
		# store spring location in memory
		jal gen_spring
		j incPlatLabs
setRocketExists:	# set rocket_exists == 1
		la $t1,rocket_exists
		addi $t2,$zero,1	
		sw $t2,0($t1)
		lw $a0,0($t6)
		lw $a1,4($t6)
		lw $a2,bufferAddress
		# get hex value of leftmost unit of curr platform
		jal convXY_func
		add $a0,$zero,$v0
		jal gen_rocket
incPlatLabs:		addi $t0,$t0,8
		addi $t4,$t4,1
		j movePlatBegL
movePlatDone:	lw $ra,0($sp)
		addi $sp,$sp,4
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
drawRPlaydone:	add $t5,$zero,$zero
		addi $t6,$zero,61
		la $t7,cStopPos
drawCStopbeg:	beq $t5,$t6,drawCStopdone
		lw $a0,0($t7)
		lw $a1,4($t7)
		lw $a2,displayAddress
		jal convXY_func
		lw $t0,purple
		sw $t0,0($v0)
		addi $t7,$t7,8
		addi $t5,$t5,1
		j drawCStopbeg
drawCStopdone:	lw $ra,0($sp)
		addi $sp,$sp,4
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

# Behaviour: add one point to the score
addOnePt:		# no arguments
		lw $t0,scoreHund
		lw $t1,scoreTens
		lw $t2,scoreOnes
		#if the ones digit is nine, increment the tens digit and set the ones digit to 0
		beq $t2,9,incTens
		#if the ones digit is NOT nine, increment the ones digit and END 
		addi $t2,$t2,1
		la $t3,scoreOnes
		sw $t2,0($t3)
		j addDone
incTens:		#the ones digit == 9 so set it to 0
		add $t2,$zero,$zero
		la $t3,scoreOnes
		sw $t2,0($t3)
		# if the tens digit is nine, increment the hundreds digit and set the tens digit to 0
		beq $t1,9,incHund
		# if the tens digit is NOT nine, increment the tens digit and END
		addi $t1,$t1,1
		la $t3,scoreTens
		sw $t1,0($t3)
		j addDone
incHund:		#the tens digit == 9 so set it to 0
		add $t1,$zero,$zero
		la $t3,scoreTens
		sw $t1,0($t3)
		# if the hundreds digit is nine, DON'T CHANGE THE SCORE
		beq $t0,9,addDone
		# if the hundreds digit is not nine, increment the hundreds digit and end
		add $t0,$t0,1
		la $t3,scoreHund
		sw $t0,0($t3)
		j addDone
addDone:		jr $ra	

# Behaviour:	Draw the score stuff on the buffer address
draw_SNum:		addi $sp,$sp,-4
		sw $ra,0($sp)
		add $t5,$zero,$a3
		#lw $a2,bufferAddress
		beq $t5,0,drawzero
		beq $t5,1,drawone
		beq $t5,2,drawtwo
		beq $t5,3,drawthree
		beq $t5,4,drawfour
		beq $t5,5,drawfive
		beq $t5,6,drawsix
		beq $t5,7,drawseven
		beq $t5,8,draweight
		beq $t5,9,drawnine
drawzero:		jal draw_zero
		j SNumEnd
drawone:		jal draw_one
		j SNumEnd
drawtwo:		jal draw_two	
		j SNumEnd
drawthree:		jal draw_three
		j SNumEnd
drawfour:		jal draw_four
		j SNumEnd
drawfive:		jal draw_five
		j SNumEnd
drawsix:		jal draw_six
		j SNumEnd
drawseven:		jal draw_seven
		j SNumEnd
draweight:		jal draw_eight
		j SNumEnd
drawnine:		jal draw_nine
		j SNumEnd
SNumEnd:		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra

# Behaviour: draw the end score
draw_EndScore:	addi $sp,$sp,-4
		sw $ra,0($sp)
		li $a0,10
		li $a1,10
		lw $a2,displayAddress
		lw $a3,scoreHund
		jal draw_SNum
		li $a0,14
		li $a1,10
		lw $a2,displayAddress
		lw $a3,scoreTens
		jal draw_SNum
		li $a0,18
		li $a1,10
		lw $a2, displayAddress
		lw $a3, scoreOnes
		jal draw_SNum
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra

# Behaviour: generate a spring (hex values) and store in memory
# $a0 = hex value of leftmost unit of platform
# $a1 = horizontal offset
gen_spring:		addi $sp,$sp,-4
		sw $ra,0($sp)
		#la $t1,spring_xy
		la $t2,spring_hex
		add $t6,$zero,$zero
springOffBeg:	beq $t6,$a1,springOffDone
		addi $a0,$a0,4
		addi $t6,$t6,1
		j springOffBeg
springOffDone:	add $a0,$a0,-128
		sw $a0,0($t2)
		addi $t2,$t2,4
		addi $a0,$a0,4
		sw $a0,0($t2)
		addi $t2,$t2,4
		addi $a0,$a0,4
		sw $a0,0($t2)
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra

# Behaviour: Given leftmost unit (in hex) of associated platform, generate rocket's hex locations and store in memory
# First nineteen must be highest, last five must be lowest
# $a0 = hex value of leftmost unit (in hex) of associated platform
gen_rocket:		# push $ra, $t0, $t4, $t5, $t6 onto stack
		addi $sp,$sp,-4
		sw $ra,0($sp)
		addi $sp,$sp,-4
		sw $t0,0($sp)
		addi $sp,$sp,-4
		sw $t4,0($sp)
		addi $sp,$sp,-4
		sw $t5,0($sp)
		addi $sp,$sp,-4
		sw $t6,0($sp)
		
		la $t1,rocket_hex
		addi $a0,$a0,4
		addi $a0,$a0,-768
		addi $a0,$a0,8
		# store top of rocket in first slot
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,124
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,116
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,112
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,112
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,112
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		addi $t1,$t1,4
		addi $a0,$a0,4
		sw $a0,0($t1)
		# pull $t6,$t5,$t4,$t0,$ra off the stack
		lw $t6,0($sp)
		addi $sp,$sp,4
		lw $t5,0($sp)
		addi $sp,$sp,4
		lw $t4,0($sp)
		addi $sp,$sp,4
		lw $t0,0($sp)
		addi $sp,$sp,4
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
# Behaviour: draws the rocket given colour code (0 == skyBlue, 1 == white and black)
# $a0 = colour code
draw_rocket:		# push $ra, $t0, $t1, $t2, $t3, $t5 on stack
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
		addi $sp,$sp,-4
		sw $t5,0($sp)
		la $t2,rocket_hex
		beq $a0,0,rocketBlue
		li $t0,0
		li $t1,19
		lw $t5,white
rocketWhiteLB:	beq $t0,$t1,rocketWhiteLE
		lw $t3,0($t2)
		blt $t3,0x10009000,rockWhiteSkip
		sw $t5,0($t3)
rockWhiteSkip:	addi $t2,$t2,4
		addi $t0,$t0,1
		j rocketWhiteLB
rocketWhiteLE:	li $t0,0
		li $t1,5
		lw $t5,black
rocketBlackLB:	beq $t0,$t1,rocketPaintEnd
		lw $t3,0($t2)
		sw $t5,0($t3)
		addi $t2,$t2,4
		addi $t0,$t0,1
		j rocketBlackLB
rocketBlue:		li $t0,0
		li $t1,24
		lw $t5,skyBlue
rocketBlueLB:	beq $t0,$t1,rocketPaintEnd
		lw $t3,0($t2)
		blt $t3,0x10009000,rockBlueSkip
		sw $t5,0($t3)
rockBlueSkip:	addi $t2,$t2,4
		addi $t0,$t0,1
		j rocketBlueLB	
rocketPaintEnd:	# pull $t5,$t3,$t2,$t1,$t0,$ra off stack
		lw $t5,0($sp)
		addi $sp,$sp,4
		lw $t3,0($sp)
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
		
# Behaviour: moves rocket down
# no parameters
move_rocket_down:	# add 128 to each rocket_hex entry
		# if top hex > 0x10009000 && top y == 25 (i.e. resting on platform that has y == 31), erase
		# push $ra, $t0, $t1, $t2,$t3 on stack
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
		
		lw $t2,rocket_hex
		bgt $t2,0x10009000,checkRocketBottom
		j moveDownRocket
checkRocketBottom:	add $a0,$t2,$zero
		lw $a1,bufferAddress
		jal convHex_func
		beq $v1,25,eraseRocket
		j moveDownRocket
eraseRocket:		la $t2,rocket_exists
		sw $zero,0($t2)
		j moveRocketEnd
moveDownRocket:	
		add $t0,$zero,$zero
		addi $t1,$zero,24
		la $t3,rocket_hex
moveRocketBeg:	beq $t0,$t1,moveRocketEnd
		lw $t2,0($t3)
		addi $t2,$t2,128
		sw $t2,0($t3)
		addi $t3,$t3,4
		addi $t0,$t0,1
		j moveRocketBeg
moveRocketEnd:	# pull $t3, $t2, $t1, $t0, $ra off stack
		lw $t3,0($sp)
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
		
# Behaviour: check if doodler's tip is touching rocket
check_touch_rocket:	# push $ra, $t0, $t1, $t2, $t3 on stack
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
		
		lw $a0,doodler_x
		lw $a1,doodler_y
		lw $a2,bufferAddress
		jal convXY_func
		# see if doodler's tip's hex is the same as any of rocket
		li $t0,0
		li $t1,24
		la $t2,rocket_hex
		
touchRocketLB:	beq $t0,$t1,noTouchRocket
		lw $t3,0($t2)
		beq $v0,$t3,yesTouchRocket
		addi $t2,$t2,4
		addi $t0,$t0,1
		j touchRocketLB
noTouchRocket:	li $v0,0
		j pullStackCheckRocket
yesTouchRocket:	li $v0,1
		j pullStackCheckRocket
pullStackCheckRocket: 	# pull $t3, $t2, $t1, $t0, $ra from stack
		lw $t3,0($sp)
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