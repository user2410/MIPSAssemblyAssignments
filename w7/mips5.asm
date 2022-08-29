.data
arr:	.space	32
readMsg0: .asciiz "$s"
readMsg1: .asciiz " = "
printMsg0: .asciiz "Largest: "
printMsg1: .asciiz "Smallest: "

.text
# smallest value t0, index t1
# largest value t2, index t3
# iterating index t4
# current address t5
# current value t6
start:	la	$a3, arr
	li	$t4, 0
	li	$t0, 0x80000000
	li	$t2, 0x7FFFFFFF
	
read:	bgt	$t4, 7, readdone

	li	$v0, 4
	la	$a0, readMsg0
	syscall
	li	$v0, 1
	addi	$a0, $t4, 0
	syscall
	li	$v0, 4
	la	$a0, readMsg1
	syscall
	
	li	$v0, 5
	syscall
	
	add	$t5, $t4, $t4
	add	$t5, $t5, $t5
	add	$t5, $t5, $a3
	sw	$v0, 0($t5)
	
	addi	$t4, $t4, 1
	j	read

readdone:	li	$t4, 0

search:		addi	$sp, $sp, -8
		sw	$s0, 4($sp)
		sw	$s1, 0($sp)
		
loop:		bgt	$t4, 7, doneloop
		add	$t5, $t4, $t4
		add	$t5, $t5, $t5
		add	$t5, $t5, $a3
		
		lw	$t6, 0($t5)
		ble	$t6, $t0, skipMax
		nop
		add	$t0, $zero, $t6
		addi	$t1, $t4, 0
skipMax:	bge	$t6, $t2, skipMin
		nop
		add	$t2, $zero, $t6
		addi	$t3, $t4, 0
skipMin:	addi	$t4, $t4, 1
		j	loop

doneloop:	lw	$s0, 0($sp)
		lw	$s1, 4($sp)
		addi	$sp, $sp, 8