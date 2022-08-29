#Laboratory Exercise 3, Home Assignment 1
.data
	i: .word 3
	k: .word 2
.text
	start:
		# load i, j to s1, s2
		lw	$s1, i
		lw	$s2, k
		
		slt	$t0, $s2, $s1
		bne	$t0, $zero, else
		addi	$t1, $t1, 1
		addi	$t3, $zero, 1
		j	endif
	else:
		addi $t2, $t2, -1
		add $t3, $t3, $t3
	endif: