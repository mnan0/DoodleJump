.data

.text
	#the goal is to increment $t1 from 0 to 100 using nested for loops
	addi $t0,$zero,0	#the increment value for the outer loop
	addi $t1,$zero,0	#the increment value for the inner loop
	addi $t2,$zero,0	#the value that will increase to 100
	addi $t3,$zero,10	#the limit for both loops
OUTER:	beq $t0,$t3,END	#for (i= 0, i<10)
INNER:	beq $t1,$t3,UPDATE	#for (j = 0, j < 10)
	addi $t2,$t2,1	#count += 1
	addi $t1,$t1,1	#j+=1
	j INNER	
UPDATE:	li $t1 0		#j=0
	addi $t0,$t0,1	#i+=1
	j OUTER
END:	li $v0 10
	syscall