#Laboratory 3, Home Assigment 2
.data
	A: .word 0x10010000 # starting address of A
	n: .half 10
	step: .half 1
.text
	start:
		add	$s1, $zero, $zero
		lw	$s2, A
		lh	$s3, n
		lh	$s4, step
		add	$s5, $zero, $zero
		
	loop:
		add	$s1, $s1, $s4
		add	$t1, $s1, $s1
		add	$t1, $t1, $t1
		add	$t1, $t1, $s2
		lw	$t0, 0($t1)
		add	$s5, $s5, $t0
		bne	$s1, $s3, loop