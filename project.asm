.data
msg1:		.asciiz "n = "
msg2:		.asciiz	"isLucky(n) = "
msgTrue:	.asciiz "true"
msgFalse:	.asciiz "false"

.text
main:	addi	$v0, $0, 4
	la	$a0, msg1
	syscall
	addi	$v0, $0, 5
	syscall
	addi	$a0, $v0, 0
	jal	isLucky
	nop
	addi	$s0, $v0, 0
	addi	$v0, $0, 4
	la	$a0, msg2
	syscall
	beq	$s0, $0, false
	nop
	la	$a0, msgTrue
	syscall
	j	true
false:	la	$a0, msgFalse
	syscall
true:	addi	$v0, $0, 10
	syscall


# isLucky(int x)
# x: $a0
# return $v0 = 1 (true) | 0 (false)
# Local variables:
# sum = t0 = 0
# digitCount = t1 = 0
# y = t2 = x
# q = t3
# r = t4
# hsum = t5

isLucky:sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	jal	prepareStack
	nop
	addi	$t0, $zero, 0
	addi	$t1, $zero, 0
	addi	$t2, $a0, 0
loop1:	beq	$t2, $0, _loop1
	nop
	addi	$t1, $t1, 1
	divu	$t3, $t2, 10
	mulu	$t6, $t3, 10
	subu	$t4, $t2, $t6
	addu	$t0, $t0, $t4
	addi	$t2, $t3, 0
	j	loop1
	nop
_loop1:	srl	$t1, $t1, 1
	addi	$t5, $0, 0
	addi	$t2, $a0, 0
loop2:	beq	$t1, $0, _loop2
	nop
	divu	$t3, $t2, 10
	mulu	$t6, $t3, 10
	subu	$t4, $t2, $t6
	addu	$t5, $t5, $t4
	addi	$t1, $t1, -1
	addi	$t2, $t3, 0
	j	loop2
	nop
_loop2:	sll	$t5, $t5, 1
	seq	$v0, $t0, $t5
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