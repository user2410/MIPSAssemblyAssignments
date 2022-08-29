# MMIO Simulator
.eqv KEY_CODE		0xFFFF0004
.eqv KEY_READY		0xFFFF0000
.eqv DISPLAY_CODE 	0xFFFF000C 	# display
.eqv DISPLAY_READY 	0xFFFF0008 	
# Digi Lab Sim
.eqv COUNTER            0xFFFF0013 	# Time counter 
.eqv MASK_CAUSE_COUNTER 0x00000400
# Led 7seg	
.eqv SEVENSEG_RIGHT 	0xFFFF0010 	
.eqv SEVENSEG_LEFT	0xFFFF0011 	

.data
string:		.asciiz "bo mon ki thuat may tinh"
buffer:		.space 1000                             
count_correct:	.asciiz "Correct chars count: "
unit_chars:	.asciiz " chars\n"
speed:		.asciiz "Speed: "
unit_wpm:	.asciiz " wpm\n"
repeat:		.asciiz	"Do you want to start typing again (Press Enter to repeat)?\n"

.text
	li 	$t0, 1
	li 	$a0,COUNTER			
	sb	$t0,0($a0)		# trigger counter exception					
	li 	$t0, 0			
	li 	$s0, 0			# $s0 = Cycle count
	li 	$s1, 0			# $s1 = 0: not counting, $s1 = 1: start counting
print_sample:
WaitForDis: 
	lw	$t2, DISPLAY_READY		
 	beq	$t2, $zero, WaitForDis 	
 	nop
 	lb	$t1, string($t0)		# t1 = string[i]
 	beq	$t1, '\0', start_readc	 	# if string[i] == NULL break
	sw	$t1, DISPLAY_CODE		
	add	$t0, $t0, 1 			# i++
	j	print_sample			

start_readc:
	li	$t0, 0			# typed chars count
	li 	$s0, 0			# reset count
	li	$s1, 1			# start counting cycles
WaitForKey:
	lw	$t2, KEY_READY		
 	beqz	$t2, WaitForKey		
 	nop
 	lw	$t3, KEY_CODE		
 	beq	$t3, 8, backspace	# check backspace
 	nop
 	beq	$t3, 10, finish		# finish if enter is pressed
 	nop
	sb	$t3, buffer($t0)	# save to buffer
 	add	$t0, $t0, 1		# i++
 	j	WaitForKey
 	nop
backspace:
 	beqz	$t0, WaitForKey		# if i == 0 => poll new key
 	nop
 	sb	$zero, buffer($t0) 	# else{ buffer[i] = NULL;
 	add	$t0, $t0, -1		#	i--;}
 	sb	$zero, buffer($t0)	
 	j	WaitForKey		
	nop

finish:	li	$s1, 0			# stop counting cycles
	# speed report
	li	$v0, 4	
	la	$a0, speed	
	syscall			
	
	addi	$a0, $t0, 0
	mulo	$a0, $a0, 132000
	divu	$a0, $a0, $s0
	li	$v0, 1
	syscall
	
	li	$v0, 4		
	la	$a0, unit_wpm		
	syscall			
	
	li	$t4, 0		# $t4: correct chars count
	li	$t0, 0		

count_chars:
	lb	$t1, string($t0) 	# $t1 = string[i]
	lb	$t2, buffer($t0)	# $t2 = buffer[i]
	beqz	$t1, report		# if(string[i] == NULL) break;
	nop
	bne	$t1, $t2, next_char	# If (String[i] == buffer[i])
	nop
	add	$t4, $t4, 1		#	$t4++;
next_char:
	add	$t0, $t0, 1		
	b	count_chars		
	nop
report:	
	# report number of correct chars
	li	$v0, 4			
	la	$a0, count_correct		
	syscall				
	
	move	$a0, $t4		
	li	$v0, 1			
	syscall				
	
	li	$v0, 4			
	la	$a0, unit_chars
	syscall				
	
	# display on 7 seg
	li	$t5, 10 
	div	$t4, $t5    		
	
	mflo	$t0			
	jal	SET_DATA_FOR_7SEG
	move	$a1, $a0		
	
	mfhi	$t0			
	jal	SET_DATA_FOR_7SEG
	nop
	jal	SHOW_7SEG_RIGHT		
	nop
	jal	SHOW_7SEG_LEFT		
	nop
start_again:
	la	$a0, repeat
	li	$v0, 4
	syscall
WaitForKey2:
	lw	$t2, KEY_READY		
 	beqz	$t2, WaitForKey2		
 	nop
 	lw	$t3, KEY_CODE		
 	beq	$t3, 10, start_readc		# if enter is pressed, start typing again
 	nop
exit_main:
	li 	$v0, 10		
	syscall				
	
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
# Function SET_DATA_FOR_7SEG : decimal to LED display
# @param [in] $t0 dec value
# @return $a0 encrypted message
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

# Exception handler
.ktext 0x80000180 	
IntSR:
 move 	$k0, $at		
 mfc0 	$k1, $13				# cause
 bne 	$k1, MASK_CAUSE_COUNTER, finish		# another exception => exit
 add	$s0, $s0, $s1				
 move 	$at, $k0				
return: eret 					
