.eqv	KEY_CODE	0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv	KEY_READY	0xFFFF0000 # =1 if has a new keycode ?
.eqv	SEVENSEG_RIGHT 	0xFFFF0010 # Dia chi cua den led 7 doan phai
.eqv	SEVENSEG_LEFT	0xFFFF0011 # Dia chi cua den led 7 doan trai
.eqv	COUNTER         0xFFFF0013 # Time counter
.eqv	MASK_CAUSE_COUNTER 0x00000400

.data
string			: .asciiz "bo mon ki thuat may tinh"
msg_correct_report	: .asciiz "Correct : "
msg_chars		: .asciiz "(chars)\n"
msg_time_report		: .asciiz "Time: "
msg_cycle		: .asciiz "(cycles)\n"
msg_repeat		: .asciiz "Do you want to start typing again (press y to repeat):\n"


.text
main:		li	$t8, COUNTER		#
		sb	$t8, 0($t8)		# trigger counter 
		li	$s1, 0
		li	$s2, 0
		la	$a0, string
		jal	strlen
		nop
		addi	$s0, $v0, 0		# s0 =  strlen(string)
loop:		li	$t0, 0			# t0 = index of current char
		li	$t1, 0			# t1 = corrrect char count
		li	$s1, 0			# s1 = counter exception cycle count
		li	$s2, 1			# s2 = 1 (start counting exception cycle)
scanc_loop:	jal	readc
		nop
		la	$t2, string
		add	$t2, $t2, $t0
		lb	$t2, 0($t2)
		bne	$t2, $v0, incorrect
		nop
		addi	$t1, $t1, 1	
incorrect:	addi	$t0, $t0, 1
		beq	$t0, $s0, repeat
		nop
		b	scanc_loop
		nop
repeat:		li	$s2, 0			# s2 = 0 (stop counting exception cycle)
		# correct char report
		la	$a0, msg_correct_report
		li	$v0, 4
		syscall
		addi	$a0, $t1, 0
		li	$v0, 1
		syscall				
		la	$a0, msg_chars
		li	$v0, 4
		syscall
		# time report
		la	$a0, msg_time_report
		li	$v0, 4
		syscall
		addi	$a0, $s1, 0
		li	$v0, 1
		syscall				
		la	$a0, msg_cycle
		li	$v0, 4
		syscall
		####
		la	$a0, msg_repeat
		li	$v0, 4
		syscall
		jal	readc
		nop
		bne	$v0, 'y', exit_main
		nop
		nop
		b	loop
		nop
		nop
exit_main:	li	$v0, 10
		syscall

# strlen() 
# $a0: stringBuffer 
# $v0: output length 
strlen:		sw	$ra, -4($sp)	 
		sw	$fp, -8($sp)
		sw	$t0, -12($sp)
		sw	$t1, -16($sp)
		addi	$sp, $sp, -16
		nop 
		addi	$v0, $0, 0 
		addi	$t0, $a0, 0 
strlen_loop: 	lb	$t1, 0($t0) 
		beq	$t1, $0, strlen_done_loop 
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

# read char
# $v0: return read char
readc:		sw	$ra, -4($sp)
		sw	$fp, -8($sp)
		sw	$k0, -12($sp)
		sw	$k1, -16($sp)
		sw	$t0, -20($sp)
		sw	$t1, -24($sp)
		addi	$sp, $sp, -24
		
		li	$k0, KEY_CODE
		li	$k1, KEY_READY
		
WaitForKey:	lw	$t1, 0($k1) # $t1 = [$k1] = KEY_READY
		nop
		beq	$t1, $zero, WaitForKey # if $t1 == 0 then Polling
		nop	
ReadKey:	lw	$t0, 0($k0) # $t0 = [$k0] = KEY_CODE
		nop
		addi	$v0, $t0, 0

		addi	$sp, $sp, 24
		lw	$ra, -4($sp) 
		lw	$fp, -8($sp)
		lw	$k0, -12($sp)
		lw	$k1, -16($sp)
		lw	$t0, -20($sp)
		lw	$t1, -24($sp)
		jr	$ra
		nop

#---------------------------------------------------------------
# Function SHOW_7SEG_RIGHT : turn on/off the 7seg
# @param [in] $a0 value to shown
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_RIGHT: 
 	sb $a0, SEVENSEG_RIGHT # assign new value
 	jr $ra
#---------------------------------------------------------------
# Function SHOW_7SEG_LEFT : turn on/off the 7seg
# @param [in] $a1 value to shown
# remark $t0 changed
#--------------------------------------------------------------- 	
SHOW_7SEG_LEFT:
 	sb $a1, SEVENSEG_LEFT # assign new value
 	jr $ra
#---------------------------------------------------------------
# Function SET_DATA_FOR_7SEG : Chuyen du lieu he 10 sang kieu ma hoa LED
# @param [in] $t0 gia tri he 10
# @return $a0 Ma hoa tung vung hien thi den led
#--------------------------------------------------------------- 	
SET_DATA_FOR_7SEG:
	beq $t0, 0, __0
	beq $t0, 1, __1
	beq $t0, 2, __2
	beq $t0, 3, __3
	beq $t0, 4, __4
	beq $t0, 5, __5
	beq $t0, 6, __6
	beq $t0, 7, __7
	beq $t0, 8, __8
	beq $t0, 9, __9
	nop
__0:	li $a0, 0x3f
	j END__F
__1:	li $a0, 0x06
	j END__F
__2:	li $a0, 0x5B
	j END__F
__3:	li $a0, 0x4f
	li $s2, 3
	j END__F
__4:	li $a0, 0x66
	j END__F
__5:	li $a0, 0x6D
	j END__F
__6:	li $a0, 0x7d
	j END__F
__7:	li $a0, 0x07
	j END__F
__8:	li $a0, 0x7f
	j END__F
__9:	li $a0, 0x6f
	j END__F
END__F:
	jr $ra		

.ktext 0x80000180 
dis_int:
	li	$t8, COUNTER
	sb	$zero, 0($t8)
	mfc0	$t8, $13	# get cause
	bne	$t8, MASK_CAUSE_COUNTER, end_process
	nop
counter_intr:
	add	$s1, $s1, $s2
end_process: 
	mtc0	$zero, $13
en_int:
	li	$t8, COUNTER
	sb	$t8, 0($t8)
next_pc:
	mfc0	$at, $14
	addi	$at, $at, 4
	mtc0	$at, $14
eret
nop
