#Laboratory Exercise 7, Home Assignment 3
.text
main:	li	$s0, 5
	li	$s1, 7
	
push:	addi	$sp, $sp, -8
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)
	
work:	add	$t0, $s0, $s1
	sw	$t0, 0($sp)
	sub	$t0, $s0, $s1
	sw	$t0, 4($sp)
	
pop:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	addi	$sp, $sp, 8