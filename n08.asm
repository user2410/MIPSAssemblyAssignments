.eqv	BUF_LEN	5000
.eqv	DISK_SIZE 8

.data
buffer:		.space BUF_LEN
d1:		.space DISK_SIZE
d2:		.space DISK_SIZE
d3:		.space DISK_SIZE
msg_input:	.asciiz "Nhap chuoi ki tu : "
buf_len_err: 	.asciiz  "Do dai chuoi khong hop le! Nhap lai.\n"
disk_ls_msg:	.asciiz  "      Disk 1                Disk 2                 Disk 3\n"
msg_dash:	.asciiz  "-----------------      ----------------       ----------------\n"
msg2:		.asciiz  "|     "
msg3:		.asciiz  "      |      "
msg4:		.asciiz  "[[ "
msg5:		.asciiz  "]]       "
msg_tryagain:	.asciiz  "Try again?"
hex: 		.byte '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'

.text
main:
main_loop:
	li	$v0, 4
	la	$a0, msg_input
	syscall
	
	li 	$v0, 8				# Get string 
	la 	$a0, buffer
	li 	$a1, BUF_LEN
	syscall
	
	la	$a0, buffer			# get input length
	jal	strlen
	nop
	addi	$s0, $v0, 0
	
	addi	$a0, $s0, 0			# check if input length divisible by 8
	jal	mod8
	nop
	beq	$v0, $0, main_loop_start_process
	nop
	la	$a0, buf_len_err		# if not, warn user
	li	$v0, 4
	syscall
	b	main_loop			#  and start again
	nop
main_loop_start_process:
	li	$v0, 4				# print " Disk1 Disk2 Disk3"
	la	$a0, disk_ls_msg
	syscall
	li	$v0, 4				# print dash line
	la	$a0, msg_dash
	syscall
	
	li	$t0, 0				# line count
	li	$t1, 0				# iterator
main_loop_proc_loop:
	beq	$t1, $s0, main_loop_proc_loop_done
	nop
	# read disc1 
	lw	$t2, buffer($t1)
	addi	$t3, $t2, 0
	sw	$t2, d1
	addi	$t1, $t1, 4
	lw	$t2, buffer($t1)
	addi	$t5, $t2, 0
	sw	$t2, d1+4
	addi	$t1, $t1, 4
	# read disc2
	lw	$t2, buffer($t1)
	addi	$t4, $t2, 0
	sw	$t2, d2
	addi	$t1, $t1, 4
	lw	$t2, buffer($t1)
	addi	$t6, $t2, 0
	sw	$t2, d2+4
	addi	$t1, $t1, 4
	# write disc3
	xor	$t3, $t3, $t4
	sw	$t3, d3
	xor	$t3, $t5, $t6
	sw	$t3, d3+4
	# print line
proc_print_line_0:	
		bne	$t0, 0, proc_print_line_1
		nop
		jal	print_line_0
		nop
		b	print_done
		nop
proc_print_line_1:
		bne	$t0, 1, proc_print_line_2
		nop
		jal	print_line_1
		nop
		b	print_done
		nop
proc_print_line_2:
		jal	print_line_2
		nop
print_done:
	addi	$t0, $t0, 1			# increment line count
	bne	$t0, 3, skip_reset_linecount
	nop
	li	$t0, 0
skip_reset_linecount:
	b	main_loop_proc_loop		# loop again
	nop
main_loop_proc_loop_done:
	li	$v0, 4				# print dash line
	la	$a0, msg_dash
	syscall
	
	li	$v0, 50				# ask if try again
	la	$a0, msg_tryagain			
	syscall
	beq	$a0, 0, main_loop		# a0 :     0 = yes;  1 = NO ;  2 = cancel
	nop
exit_main:
	li	$v0, 10
	syscall

	
#### PROCEDURES	AND FUNCTIONS ####

# strlen
# a0: string address
# v0: returned value
strlen:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	sw	$t0, -12($sp)
	sw	$t1, -16($sp)
	addi	$sp, $sp, -16
	nop
	addi	$v0, $0, 0
	addi	$t0, $a0, 0
strlen_loop:
	lb	$t1, 0($t0)
	beq	$t1, $0, strlen_done_loop		# null char
	nop
	beq	$t1, '\n', strlen_done_loop		# new line char
	nop
	beq	$t1, '\r', strlen_done_loop		# line feed char (windows)
	nop
	addi	$t0, $t0, 1
	addi	$v0, $v0, 1
	j	strlen_loop
	nop
strlen_done_loop:
	addi	$sp, $sp, 16
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	lw	$t0, -12($sp)
	lw	$t1, -16($sp)
	jr	$ra
	nop
	
	
# mod 8
# a0: integer number
# v0=a0 mod 8
mod8:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	sw	$t0, -12($sp)
	addi	$sp, $sp, -12
	
	li	$v0, 0
	srl	$t0, $a0, 3
	sll	$t0, $t0, 3
	sub	$v0, $a0, $t0
	
	addi	$sp, $sp, 12
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	lw	$t0, -12($sp)
	jr	$ra
	nop
	
# read disc from buffer
# a0: disk address
# a1: buffer address
# buffer address
read_disc:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	sw	$t0, -12($sp)
	sw	$t1, -16($sp)
	sw	$t2, -20($sp)
	addi	$sp, $sp, -20
	
	li	$t0, 0
read_disc_loop:
	beq	$t0, DISK_SIZE, read_disc_done_loop
	nop
	add	$t1, $a1, $t0
	lb	$t1, 0($t1)
	add	$t2, $a0, $t0
	sb	$t1, 0($t2)
	addi	$t0, $t0, 1
	b	read_disc_loop
	nop
read_disc_done_loop:
	
	addi	$sp, $sp, 20
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	sw	$t0, -12($sp)
	sw	$t1, -16($sp)
	sw	$t2, -20($sp)
	jr	$ra
	nop

# print line 0
print_line_0:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	addi	$sp, $sp, -8
	
	la	$a0, msg2
	li	$v0, 4
	syscall
	la	$a0, d1
	jal	print_4bytes_char
	nop
	la	$a0, msg3
	li	$v0, 4
	syscall
		
	la	$a0, msg2
	li	$v0, 4
	syscall
	la	$a0, d2
	jal	print_4bytes_char
	nop
	la	$a0, msg3
	li	$v0, 4
	syscall
		
	la	$a0, msg4
	li	$v0, 4
	syscall
	la	$a0, d3
	jal	print_4bytes_hex
	nop
	la	$a0, msg5
	li	$v0, 4
	syscall
	
	li	$a0, '\n'
	li	$v0, 11
	syscall
		
	addi	$sp, $sp, 8
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	jr	$ra
	nop

# print line 1
print_line_1:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	addi	$sp, $sp, -8
	
	la	$a0, msg2
	li	$v0, 4
	syscall
	la	$a0, d1
	jal	print_4bytes_char
	nop
	la	$a0, msg3
	li	$v0, 4
	syscall
	
	la	$a0, msg4
	li	$v0, 4
	syscall
	la	$a0, d3
	jal	print_4bytes_hex
	nop
	la	$a0, msg5
	li	$v0, 4
	syscall
	
	la	$a0, msg2
	li	$v0, 4
	syscall
	la	$a0, d2
	jal	print_4bytes_char
	nop
	la	$a0, msg3
	li	$v0, 4
	syscall
	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	addi	$sp, $sp, 8
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	jr	$ra
	nop

# print line 2
print_line_2:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	addi	$sp, $sp, -8
	
	la	$a0, msg4
	li	$v0, 4
	syscall
	la	$a0, d3
	jal	print_4bytes_hex
	nop
	la	$a0, msg5
	li	$v0, 4
	syscall
	
	la	$a0, msg2
	li	$v0, 4
	syscall
	la	$a0, d1
	jal	print_4bytes_char
	nop
	la	$a0, msg3
	li	$v0, 4
	syscall
	
	la	$a0, msg2
	li	$v0, 4
	syscall
	la	$a0, d2
	jal	print_4bytes_char
	nop
	la	$a0, msg3
	li	$v0, 4
	syscall
	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	addi	$sp, $sp, 8
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	jr	$ra
	nop


# print chars
# a0: string address
print_4bytes_char:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	sw	$t0, -12($sp)
	sw	$t1, -16($sp)
	addi	$sp, $sp, -16
	
	li	$t0, 0
	addi	$t1, $a0, 0
print_4bytes_char_loop:
	beq	$t0, DISK_SIZE, print_4bytes_char_done_loop
	nop
	add	$a0, $t1, $t0
	lb	$a0, ($a0)
	li	$v0, 11
	syscall
	addi	$t0, $t0, 1
	b	print_4bytes_char_loop
	nop
print_4bytes_char_done_loop:
	
	addi	$sp, $sp, 16
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	lw	$t0, -12($sp)
	lw	$t1, -16($sp)
	jr	$ra
	nop


# print hex
print_4bytes_hex:
	sw	$ra, -4($sp)	
	sw	$fp, -8($sp)
	sw	$t0, -12($sp)
	sw	$t1, -16($sp)
	sw	$t2, -20($sp)
	sw	$t3, -24($sp)
	sw	$t4, -28($sp)
	sw	$t5, -32($sp)
	addi	$sp, $sp, -32
	
	li	$t0, 0
	addi	$t1, $a0, 0
	la	$t2, hex
print_4bytes_hex_loop:
	beq	$t0, DISK_SIZE, print_4bytes_hex_done_loop
	nop
	add	$t3, $t1, $t0
	lb	$t3, ($t3)
	srl	$t4, $t3, 4
	sll	$t5, $t4, 4
	sub	$t5, $t3, $t5
	
	add	$t4, $t2, $t4
	lb	$a0, ($t4)
	li	$v0, 11
	syscall
	
	add	$t5, $t2, $t5
	lb	$a0, ($t5)
	li	$v0, 11
	syscall
	
	li	$a0, ','
	syscall
	
	addi	$t0, $t0, 1
	b	print_4bytes_hex_loop
	nop
print_4bytes_hex_done_loop:

	addi	$sp, $sp, 32
	lw	$ra, -4($sp)
	lw	$fp, -8($sp)
	lw	$t0, -12($sp)
	lw	$t1, -16($sp)
	lw	$t2, -20($sp)
	lw	$t3, -24($sp)
	lw	$t4, -28($sp)
	lw	$t5, -32($sp)
	jr	$ra
	nop
