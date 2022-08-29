#Laboratory Exercise 5, Home Assignment 3
.data
string: .space 21
Message1: .asciiz "Nhap xau khong qua 20 ki tu: ”
Message2: .asciiz "Do dai la "
.text
main:
get_string:
	# print message1
	la	$a0, Message1
	li	$v0, 4
	syscall
	#get string
	li	$v0, 8
	la	$a0, string
	li	$a1, 21
	syscall
	#set null character
	sb	$zero, 21($a0)
get_length:
	#la	$a0, string		# a0 = Address(string[0])
	xor	$a1, $zero, $zero	# a1 = length = 0
	xor	$t0, $zero, $zero	# t0 = i = 0
check_char:
	add	$t1, $a0, $t0		# t1 = a0 + t0
					#= Address(string[0]+i)
	lb	$t2, 0($t1)		# t2 = string[i]
	beq	$t2, $zero, end_of_str	# Is null char?
	addi	$a1, $a1, 1		
	addi	$t0, $t0, 1
	j	check_char
end_of_str:
end_of_get_length:

print_reverse:
	li	$v0, 11			# set syscall
	la	$s0, string		# string
	sub	$t2, $a1, 1
	addu	$t0, $t2, $zero		# t0 = i = length-1
check_index:
	add	$t1, $s0, $t0		# t1 = a0 + t0
					#= Address(string[0]+i)
	
	# print character
	lb	$a0, 0($t1)
	syscall
	
	# decrement index
	sub	$t0, $t0, 1
	blt	$t0, $zero, beg_of_str
	nop
	j	check_index
beg_of_str:
end_of_print_reverse: