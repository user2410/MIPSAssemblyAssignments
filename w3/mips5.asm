#Laboratory 3, Home Assigment 2
.data
	A: .word 0x10010000 # starting address of A
	n: .half 10
	step: .half 1
.text
	start:
		li	$s1, $zero
		lw	$s2, A
		lh	$s3, n
		lh	$s4, step
		li	$s5, $zero
		
	loop:
		add	$s1, $s1, $s4
		add	$t1, $s1, $s1
		add	$t1, $t1, $t1
		add	$t1, $t1, $s2
		lw	$t0, 0($t1)
		add	$s5, $s5, $t0

		# i<n
		slt	$t2, $s1, $s3
		bne	$t2, $zero, loop
		
		# i<=n
		sgt	$t2, $s1, $s3
		beq	$t2, $zero, loop
		
		# sum>=0
		slt	$t2, $s5, $zero
		beq	$t2, $zero, loop
		
		# A[i]==0
		beq	$t0, $zero, loop