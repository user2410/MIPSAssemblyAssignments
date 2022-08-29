.data
msg0: .asciiz "Nhap so: "
msg1: .asciiz "The sum of ("
msg2: .asciiz ") and ("
msg3: .asciiz ") is("
msg4: .asciiz ")"
.text
	la	$a0, msg0
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	addu	$s0, $v0, $zero
	
	la	$a0, msg0
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	addu	$s1, $v0, $zero
		
	la	$a0, msg1
	li	$v0, 4
	syscall
	
	addu	$a0, $s0, $zero
	li	$v0, 1
	syscall
	
	la	$a0, msg2
	li	$v0, 4
	syscall
	
	addu	$a0, $s1, $zero
	li	$v0, 1
	syscall
	
	la	$a0, msg3
	li	$v0, 4
	syscall
	
	addu	$a0, $s0, $s1
	li	$v0, 1
	syscall
	
	la	$a0, msg4
	li	$v0, 4
	syscall
