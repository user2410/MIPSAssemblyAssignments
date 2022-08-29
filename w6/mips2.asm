.data
A: .word 7, -2, 5, 1, 5, 6, 7, 3, 6, 8, 8, 59, 5
Aend: .word

.text
main:	la	$a0, A
	la	$a1, Aend
	addi	$a1, $a1, -4	#$a1 = Address(A[n-1])
	j	sort
after_sort:	li	$v0, 10
		syscall
end_main:
#--------------------------------------------------------------
#procedure sort (ascending selection sort using pointer)
#register usage in sort program
#$a0 pointer to the first element in unsorted part
#$a1 pointer to the last element in unsorted part
#$t0 temporary place for value of last element
#$v0 pointer to max element in unsorted part
#$v1 value of max element in unsorted part
#--------------------------------------------------------------
sort:	beq	$a0, $a1, done
	j	max
after_max:	lw	$t0, 0($a1)	#load last element into $t0
		sw	$t0, 0($v0)	
		sw	$v1, 0($a1)
		addi	$a1, $a1, -4
		j	sort
done:	j	after_sort

max:	addi	$v0, $a0, 0	#init max pointer to first element
	lw	$v1, 0($v0)	#init max value to first value
	addi	$t0, $a0, 0	#init next pointer to first
loop:	beq	$t0, $a1, ret	#if next=last, return
	addi	$t0, $t0, 4	#advance to next element
	lw	$t1, 0($t0)	#load next element into $t1
	slt	$t2, $t1, $v1	# next < max ?
	bne	$t2, $zero, loop
	addi	$v0, $t0, 0	#next element is new max element
	addi	$v1, $t1, 0	#next value is new max value
	j	loop		#change completed
ret:
	j	after_max
