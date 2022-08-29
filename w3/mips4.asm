#Laboratory Exercise 3, Home Assignment 1
.data
	i: .word 3
	k: .word 2
	m: .word 4
	n: .word 5
.text
	start:
		# load i, j to s1, s2
		lw	$s1, i
		lw	$s2, k
		lw	$s3, m
		lw	$s4, n
		
		# i<k
		slt	$t0, $s1, $s2
		bne	$t0, $zero, else
				
		# i>=k
		slt	$t0, $s1, $s2
		beq	$t0, $zero, else
		
		# i+k<=0
		add	$s1, $s1, $s2
		sgt	$t0, $s1, $zero
		beq	$t0, $zero, else
		
		#i+k>m+n
		add	$s1, $s1, $s2
		add	$s3, $s3, $s4
		sgt	$t0, $s1, $s3
		bne	$t0, $zero, else
		
		addi	$t1, $t1, 1
		addi	$t3, $zero, 1
		j	endif
	else:
		addi $t2, $t2, -1
		add $t3, $t3, $t3
	endif:
