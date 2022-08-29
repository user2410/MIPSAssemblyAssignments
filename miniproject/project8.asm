.data
strPool:	.space	10000
strTop:		.word	0	# address of top of strPool
studentNum:	.word	0
recordArr:	.space	800	# space for 100 records, 8 bytes for each record

msgAskStudentNum:	.asciiz "Number of students in class (maximum 100 students): "
msgName:		.asciiz "Name: "
msgScore:		.asciiz "Score: "
msgPrintStudents:	.asciiz "\n=====Students=====\n"
msgSort:		.asciiz "\nSorting students ...\n"

.text
main:	la	$t0, strPool
	sw	$t0, strTop
	
	# ask for number of students in class
	addi	$v0, $0, 4
	la	$a0, msgAskStudentNum
	syscall
	
	addi	$v0, $0, 5		
	syscall
	blt	$v0, 100, user_input
	nop
	addi	$v0, $0, 100
user_input:
	sw	$v0, studentNum
	addi	$t0, $0, 0
	lw	$t1, studentNum
# user input loop
main_input_loop:
	beq	$t0, $t1, main_done_input
	nop
	sll	$t4, $t0, 3		
	la	$t3, recordArr
	addu	$t3, $t3, $t4		# $t3: base address of current record
	# ask student's name
	addi	$v0, $0, 4
	la	$a0, msgName
	syscall
	addi	$v0, $0, 8
	lw	$a0, strTop
	addi	$a1, $0, 100
	syscall
	jal	strLen
	nop
	# save student's name
	sw	$a0, 0($t3)		# save name to record
	addi	$t4, $v0, 0
	addu	$t4, $t4, $a0
	sb	$0, 0($t4)		# add null character
	addi	$t4, $t4, 1
	sw	$t4, strTop
	# ask student's score
	addi	$v0, $0, 4
	la	$a0, msgScore
	syscall
	addi	$v0, $0, 5
	syscall
	# save student's score
	sw	$v0, 4($t3)
	addi	$t0, $t0, 1
	j	main_input_loop
	nop
main_done_input:
	jal	sortStudents
	nop
	jal	printStudents
	nop
	# Exitting syscall
	addi	$s0, $v0, 0
	addi	$v0, $zero, 10
	syscall


# strlen()
# $a0: stringBuffer
# $v0: output length
strLen:	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	jal	prepareStack
	nop
	addi	$v0, $0, 0
	addi	$t0, $a0, 0
strLen_loop:
	lb	$t1, 0($t0)
	beq	$t1, $0, strLen_done_loop
	nop
	addi	$t0, $t0, 1
	addi	$v0, $v0, 1
	j	strLen_loop
	nop
strLen_done_loop:
	jal	destroyStack
	nop
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	jr	$ra
	nop


# void printStudents()
printStudents:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	jal	prepareStack
	nop
	addi	$v0, $0, 4
	la	$a0, msgPrintStudents
	syscall
	addi	$t0, $0, 0
	lw	$t1, studentNum
printStudents_loop:
	beq	$t0, $t1, printStudents_done_loop
	nop
	sll	$t2, $t0, 3
	la	$t3, recordArr
	addu	$t3, $t3, $t2		# $t3: base address of current record
	# print name
	addi	$v0, $0, 4
	la	$a0, msgName
	syscall
	lw	$a0, 0($t3)
	syscall
	# print score
	la	$a0, msgScore
	syscall
	addi	$v0, $0, 1
	addi	$t4, $t3, 4
	lw	$a0, 0($t4)
	syscall
	addi	$v0, $0, 11
	li	$a0, '\n'
	syscall
	# increment $t0
	addi	$t0, $t0, 1
	j	printStudents_loop
	nop
printStudents_done_loop:
	jal	destroyStack
	nop
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	jr	$ra
	nop


# void sortStudents()
sortStudents:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	jal	prepareStack
	nop
	addi	$v0, $0, 4
	la	$a0, msgSort
	syscall
	lw	$t0, studentNum
	addi	$t1, $0, 0	# i
	addi	$t2, $t0, -1
sortStudents_loop1:
	beq	$t1, $t2, sortStudents_done_loop1
	nop
	addi	$t3, $0, 0	# swapped = false
	addi	$t4, $0, 0	# j
	sub	$t5, $t2, $t1
sortStudents_loop11:
	beq	$t4, $t5, sortStudents_done_loop11
	nop
	sll	$t7, $t4, 3
	la	$t6, recordArr
	addu	$t6, $t6, $t7	# $t6: base address of j_th record
	lw	$t7, 4($t6)
	lw	$t8, 12($t6)
	ble	$t7, $t8, sortStudents_skip_swap
	nop
	sw	$t7, 12($t6)
	sw	$t8, 4($t6)
	lw	$t7, 0($t6)
	lw	$t8, 8($t6)
	sw	$t7, 8($t6)
	sw	$t8, 0($t6)
	addi	$t3, $0, 1	# swapped = true
sortStudents_skip_swap:
	addi	$t4, $t4, 1
	j	sortStudents_loop11
	nop
sortStudents_done_loop11:
	beq	$t3, $0, sortStudents_done_loop1
	addi	$t1, $t1, 1
	j	sortStudents_loop1
	nop
sortStudents_done_loop1:
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
