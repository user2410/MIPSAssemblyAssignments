#Laboratory Exercise 4, Assignment 2
.text
start:
	li	$s0, 0xfeedbeef
	
	# $s1 = MSB of $s0
	srl	$s1, $s0, 24
	
	# clear LSB of $s0
	andi	$s0, 0xffffff00
	
	# set LSB of $s0
	ori	$s0, 0x000000ff
	
	# clear $s0
	andi	$s0, 0