.data
A: .word -2, 6, -1, 3, -2

.text
main:	la	$a0, A
	li	$a1, 5
	j	mspfx
continue:
lock:	j	lock
	nop
end_of_main:

mspfx:	addi	$v0,$zero,0	# length
	addi	$v1,$zero,0	# max sum
	addi	$t0,$zero,0	# index i
	addi	$t1,$zero,0	# running sum in $t1
loop:	add	$t2, $t0, $t0
	add	$t2, $t2, $t2
	add	$t3, $t2, $a0
	
	lw	$t4, 0($t3)	# t4 = A[i]
	add	$t1, $t1, $t4
	slt	$t5, $v1, $t1
	bne	$t5, $zero, mdfy	# max sum < running sum
	j	test
mdfy:	addi	$v0, $t0, 1	# new max-sum prefix has length i+1
	addi	$v1, $t1, 0	# new max sum is the running sum
test:	addi	$t0, $t0, 1
	slt	$t5, $t0, $a1
	bne	$t5, $zero, loop
mspfx_end: