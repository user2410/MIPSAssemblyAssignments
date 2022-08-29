.data
A: .space 52 # input string size, include terminate and \n
InputMessage: .asciiz "Nhap xau:"
.text
main:
get_string: 
li $v0, 54 # show input dialog string
la $a0, InputMessage
la $a1, A
li $a2, 200
syscall

#--------------------------------------------------------------------------------------------
get_length: la $a0, A # a0 = Address(string[0])
 add $v0, $zero, $zero # v0 = length = 0
 add $t0, $zero, $zero # t0 = i = 0
 check_char: add $t1, $a0, $t0 # t1 = a0 + t0
 			      	# = Address(string[0]+i)
 	lb $t2, 0($t1) # t2 = string[i]
 	beq $t2,$zero,end_of_str # Is null char?
 	addi $v0, $v0, 1 # v0=v0+1 ~ length=length+1
 	addi $t0, $t0, 1 # t0=t0+1 ~ i = i + 1
 	j check_char
 end_of_str: addi $v1, $v0, -1 # string length = v0 - 1 (except for the \n character)
 
 la $a0, A # load address of input string
 add $a1, $v1, $zero # load length
 
j bubble_sort
bubble_sort: li $t0, 0 # Init i = 0
li $t1, 0 # init j = 0
loop1: bge $t0, $a1, end_loop1 # end loop if i >= n
sub $a2, $a1, 1
sub $a2, $a2, $t0 # a2 = n - i - 1
li $t1, 0 # init j = 0
loop2: bge $t1, $a2, update_loop1 # end loop if j >= n - i -1
add $t2, $a0, $t1 # Address of A[j]
lb $t3, 0($t2) # t3 = value of A[j]
addi $t4, $t1, 1 # t4 = j + 1
add $t4, $a0, $t4 # Address of A[j+1]
lb $t5, 0($t4) # t5 = value of A[j+1]
bgt $t3, $t5, swap # swap if A[j] > A[j+1]
update_loop2: addi $t1, $t1, 1 # j++
j loop2
update_loop1: addi $t0, $t0, 1 #i++
j loop1

swap: sb $t3, 0($t4)
sb $t5, 0($t2)
j update_loop2
end_loop1:
