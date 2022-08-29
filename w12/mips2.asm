.eqv	IN_ADDRESS_HEXA_KEYBOARD	0xFFFF0012

.data
msg:	.asciiz "Button pressed!\n"

.text
main:
	li	$t1, IN_ADDRESS_HEXA_KEYBOARD
	li	$t3, 0x80
	sb	$t3, 0($t1)
	
Loop:	nop
	nop
	nop
	nop
	b	Loop
	nop
end_main:
	li	$v0, 10
	syscall

.ktext	0x80000180
IntSR:	addi	$v0, $0, 4
	la	$a0, msg
	syscall
	
next_pc:mfc0	$at, $14
	addi	$at, $at, 4
	mtc0	$at, $14

return:	eret
	nop