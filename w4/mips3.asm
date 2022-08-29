#Laboratory Exercise 4, Assignment 3
.text
start:
	li	$s1, -100
	
	# abs $s0, s1
	sra	$s2, $s1, 31
	add	$s0, $s1, $s2
	xor	$s0, $s0, $s2
	
	# move $s0,s1
	and	$s0, $s1, $s1
	
	# not $s0
	nor	$s0, $s0, $s0
	
	# ble $s1,s2,L
	li	$s2, -150
	sub	$s3, $s2, $s1
	bltz	$s3, done3
L:
done3:
	