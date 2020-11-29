.data
	#displayAddress: .word 0x10008000
.text
	add $t0,$zero,$zero	#$t0 = 0
	addi $t1,$zero,0	#$t1 = 0
	addi $t2,$zero,100	#$t2 = 100
START:	beq $t1, $t2, END
	addi $t1,$t1,1
	j START		
END:	li $v0, 10
	syscall
