#Laboratory Exercise 4, Assignment 1
.text
start:
	li 	$s1, -200
	li	$s2, -100
	
	li	$t0, 0
	addu	$s3, $s1, $s2
	xor	$t1, $s1, $s2
	
	bltz	$t1, exit
	slt	$t2, $s3, $s1
	bltz	$s1, negative
	beq	$t2, $zero, exit
	j	overflow
	
negative:
	bne	$t2, $zero, exit
	
overflow:
	li	$t0, 1
exit: