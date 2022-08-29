.data
	A: .word 0x10010000
.text
	# s0 base array address
	lw	$s0, A
	
	# s1 max abs element so far
	# s4 max element so far
	li	$s1, 0
	li	$s4, 0

	# t0 index, t1 step
	li	$t0, 0
	li	$t1, 1
	
	# load integer list
	# -6, 4, 10, 11, -12
	# s3 element count
	li	$s3, 5
	
	add	$t0, $t0, $t1
	add 	$t2, $t0, $t0
	add	$t2, $t2, $t2
	add	$t2, $t2, $s0
	li	$s2, -6
	sw	$s2, 0($t2)
	
	add	$t0, $t0, $t1
	add 	$t2, $t0, $t0
	add	$t2, $t2, $t2
	add	$t2, $t2, $s0
	li	$s2, 4
	sw	$s2, 0($t2)
	
	add	$t0, $t0, $t1
	add 	$t2, $t0, $t0
	add	$t2, $t2, $t2
	add	$t2, $t2, $s0
	li	$s2, -10
	sw	$s2, 0($t2)
	
	add	$t0, $t0, $t1
	add 	$t2, $t0, $t0
	add	$t2, $t2, $t2
	add	$t2, $t2, $s0
	li	$s2, 11
	sw	$s2, 0($t2)
	
	add	$t0, $t0, $t1
	add 	$t2, $t0, $t0
	add	$t2, $t2, $t2
	add	$t2, $t2, $s0
	li	$s2, -12
	sw	$s2, 0($t2)
	
	# reset index
	li	$t0, 0
	
	loop:
	add	$t0, $t0, $t1
	add 	$t2, $t0, $t0
	add	$t2, $t2, $t2
	add	$t2, $t2, $s0
	
	lw	$t3, 0($t2)
	slt	$t4, $t3, $zero
	beq	$t4, $zero, cont1
	# t5 absolute value of t3
	sub	$t5, $zero, $t3
	j	cont2
	cont1:
	add	$t5, $t3, $zero
	cont2:
	sgt	$t4, $t5, $s1
	beq	$t4, $zero, not_assign
	add	$s1, $t5, $zero
	add	$s4, $t3, $zero
	
	sgt	$t4, $t0, $s3
	bne	$t4, $zero, end
	
	not_assign:
	sgt	$t4, $t0, $s3
	bne	$t4, $zero, end	
	j	loop
	
	end:
		