#Laboratory Exercise 7, Home Assignment 4
.data
Message: .asciiz "Ket qua tinh giai thua la: "
.text
main:	jal	WRAP

print:	add	$a1, $v0, $zero
	li	$v0, 56
	la	$a0, Message
	syscall
quit:	li	$v0, 10
	syscall
endmain:

WRAP:	sw	$fp, -4($sp)
	addi	$fp, $sp, 0
	addi	$sp, $sp, -8
	sw	$ra, 0($sp)
	
	li	$a0, 6
	jal	FACT
	nop
	
	lw	$ra, 0($sp)
	addi	$sp, $fp, 0
	lw 	$fp, -4($sp)
	jr	$ra
wrap_end:

#param[in] $a0 integer N
#return	$v0: the largest value
FACT:	sw	$fp, -4($sp)
	addi	$fp, $sp, 0
	addi	$sp, $sp, -12	#allocate space for $fp,$ra,$a0 in stack
	sw	$ra, 4($sp)
	sw	$a0, 0($sp)
	
	slti	$t0, $a0, 2
	beq	$t0, $zero, recurse
	nop
	li	$v0, 1
	j	return
	nop
recurse:	addi	$a0, $a0, -1
		jal	FACT
		nop
		lw	$v1, 0($sp)
		mult	$v1, $v0
		mflo	$v0
return:	lw	$ra, 4($sp)
	lw	$a0, 0($sp)
	addi	$sp, $fp, 0
	lw	$fp, -4($sp)
	jr	$ra
fact_end: