.text
main:	addi	$a0, $0, 128308
	jal	isLucky
	nop
	addi	$s0, $v0, 0
	addi	$v0, $zero, 10
	syscall

isLucky:sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	jal	prepareStack
	nop
	
	jal	destroyStack
	nop
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	jr	$ra
	nop


prepareStack:
	sw	$t0, -12($sp)
	sw	$t1, -16($sp)
	sw	$t2, -20($sp)
	sw	$t3, -24($sp)
	sw	$t4, -28($sp)
	sw	$t5, -32($sp)
	sw	$t6, -36($sp)
	sw	$t7, -40($sp)
	sw	$t8, -44($sp)
	sw	$t9, -48($sp)
	addi	$sp, $sp, -48
	jr	$ra
	nop
destroyStack:
	addi	$sp, $sp, 48
	lw	$t0, -12($sp)
	lw	$t1, -16($sp)
	lw	$t2, -20($sp)
	lw	$t3, -24($sp)
	lw	$t4, -28($sp)
	lw	$t5, -32($sp)
	lw	$t6, -36($sp)
	lw	$t7, -40($sp)
	lw	$t8, -44($sp)
	lw	$t9, -48($sp)
	jr	$ra
	nop
