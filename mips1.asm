.data
x: .word 0x01020304
msg: .asciiz "abcdef ghik lmnop"
.text
	la $a0, msg
	li $v0, 4
	syscall
	
	addi $t1, $zero, 2
	addi $t2, $zero, 3
	add $t0, $t1, $t2