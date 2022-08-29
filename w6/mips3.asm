.data
A: .word 7, -2, 5, 1, 5, 6, 7, 3, 6, 8, 8, 59, 5
Alen: .word 13

.text
main:	la	$a0, A
	lw	$a1, Alen
	
# for(int i=0; i<(size-1); i++)
#	{
#		for(int j=0; j<(size-i-1); j++)
#		{
#			if(A[j] > A[j+1])
#			{
#				int temp = A[j+1];
#				A[j+1] = A[j];
#				A[j] = temp;
#			}
#		}
#	}

# t0: i, s0 = A[j]
# t1: j, s1 = A[j]
# t2: test value of i
# t3: test value of j
# t4: comparison result
# t5: address value
# t6: byte index
# s2: temp

sort:	addi	$t0, $zero, 0		# i = 0
	addi	$t2, $a1, -1
loop:	slt	$t4, $t0, $t2		# if i < size-1
	beq	$t4, 0, endloop
	nop
	sub	$t3, $t2, $t0		# t3 = size-1-i
	addi	$t1, $zero, 0		# j = 0
innerloop:
	slt	$t4, $t1, $t3		# if j < size-1-i
	beq	$t4, 0, endinnerloop
	nop
	
	add	$t6, $t1, $t1
	add	$t6, $t6, $t6
	add	$t5, $a0, $t6		
	lw	$s0, 0($t5)		# s0 = A[j]
	
	# addi	$t6, $t6, 4
	# addi	$t5, $a0, $t6
	addi	$t5, $t5, 4
	lw	$s1, 0($t5)		# s1 = A[j+1]
	
	sgt	$t4, $s0, $s1		# if A[j] > A[j+1]
	beq	$t4, 0, skipswap
	nop
	addi	$s2, $s1, 0		# temp = A[j+1]
	sw	$s0, 0($t5)		# A[j+1] = A[j]
	addi	$t5, $t5, -4		# t5: address of A[j]
	sw	$s2, 0($t5)		# A[j] = temp
skipswap:
	addi	$t1, $t1, 1		# j++
	j	innerloop
endinnerloop:
	addi	$t0, $t0, 1		# i++
	j	loop
endloop:
endsort: