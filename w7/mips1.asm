#Laboratory Exercise 7 Home Assignment 1
.text
main:	li	$a0, -1324	#load input parameter
	jal	abs
	nop
	li	$v0, 10		#terminate
	syscall
endmain:
abs:	sra	$t0, $a0, 31
	add	$s0, $a0, $t0
	xor	$s0, $s0, $t0
done:	jr	$ra