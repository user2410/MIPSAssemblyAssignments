#Laboratory Exercise 4, Assignment 4
.text
start:
	li 	$s1, 0xf0000001
	li	$s2, 0xf0000001
	
	li	$t0, 0
	addu	$s3, $s1, $s2
	xor	$t1, $s1, $s2
	bltz	$t1, exit	
	
	slt	$t2, $s3, $s1
	bltz	$s1, negative
	beq	$t2, $zero, exit
	
	# if the sum doesn’t have the same sign with either operands
	xor	$t1, $s3, $s1
	bltz	$t1, overflow
	
	j	overflow
	
negative:
	bne	$t2, $zero, exit
	
overflow:
	li	$t0, 1
exit: