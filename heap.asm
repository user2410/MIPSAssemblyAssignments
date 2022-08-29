.data
    buffer: .space 28
 done_str: .asciiz "DONE"
 enter_players_name: .asciiz    "Enter player's last name:           "
 enter_players_points: .asciiz  "Enter player's points per game:     "
 enter_players_minutes: .asciiz "Enter player's minutes per game:    "
 newline: .asciiz "\n"
 blank_text: .asciiz "         " 
.text
 main:   addi $s4,$zero,0 # count number of players 
 loop_in:la $a0,enter_players_name
  li $v0, 4 
  syscall # load and print asking for player's last name
  li $v0, 8 # take the last name of the player 
  la $a0,buffer 
  li $a1,28
  syscall
  # count number of characters in the last name 
  la $t1, buffer # lower array pointer = array base
  la $t2, buffer # start upper pointer at beginning
  LengthLp:
  lb $t3, ($t2) # grab the character at upper ptr
  beqz $t3, LengthDn # if $t3 == 0, we're at the terminator
  addi $t2, $t2, 1 # count the character
  b LengthLp # repeat the loop
  LengthDn:
  addi $t2, $t2, -1  
  sub $s7,$t2,$t1 # number of characters are entered
  addi $t3,$zero,4
  beq $s7,$t3,compDone # compare with "DONE" to finish the program 
loop_i1:la $a0,enter_players_points
  li $v0, 4 
  syscall # load and print asking for player's points per game 
  li $v0, 6 # read float 1
  syscall # do it
  mov.s $f1, $f0
  la $a0,enter_players_minutes
  li $v0, 4 
  syscall # load and print asking for player's minutes per game   
  li $v0, 6 # read float 2
  syscall # do it
  mov.s $f2, $f0  
  mtc1 $zero, $f3 #move to FP registers
  cvt.s.w $f4, $f3
  c.eq.s $f1, $f4
  bc1t zero_float
  c.eq.s $f2, $f4
  bc1t zero_float
  div.s $f5, $f1, $f2
 #--------------DONE ASKING--------## $s4: number of players
zero_back: beq $s4,$zero,first_player
  addi $s4,$s4,1# Add new players and allocate new memory, deallocate the old memory 
  addi $t3,$zero,4
  addi $t4,$zero,28
  mult $s4,$t4
  mflo $t5 # new number of bytes of name memory 
  mult $s4,$t3
  mflo $t6 # new number of bytes of point/min memory 
  li  $v0,9      # Allocate new memory for name memory
  move $a0,$t5 
  syscall        # $v0 <= address of name memory 
  move $s1,$v0  # new address of name memory
  li  $v0,9      # Allocate new memory for point/min memory 
  move $a0,$t6
  syscall        # $v0 <= address of point/min memory 
  move $s2,$v0  #new address  of point/min memory  
  #---Copy data from old mem to new mem --#
  # $s4-1: number of players in old mem 
  # $s5: address of old name memory 
  # $s6: address of old point/min memory 
  # $s1: address of new name memory 
  # $s2: address of new point/min memory 
  addi $s7,$zero,0 
loop_copy:
  addi $t3,$zero,28
  mult $s7,$t3
  mflo $t4
  addi $t5,$zero,4
  mult $s7,$t5
  mflo $t6  
  add $t0,$t4,$s5 # copy names 
  add $t1,$t4,$s1
  add $t2,$t6,$s6 # copy point/min 
  add $t3,$t6,$s2 
# change number of characters  
  addi $t7,$zero,0
loop1:  add $s0,$t0,$t7
  add $t4,$t1,$t7
  lw $t5,0($s0) # copy name of the player 
  sw $t5,0($t4)
  addi $t7,$t7,4
  addi $t5,$zero,28
  bne $t7,$t5,loop1  
  l.s $f3,0($t2)
  s.s $f3,0($t3) # copy point/min of the player 
  addi $s7,$s7,1
  addi $t0,$s4,-1
  beq $s7,$t0,save_new_player  #save until the end of the old memory 
  j loop_copy
save_new_player: 
  addi $t0,$s4,-1
  addi $t3,$zero,28
  mult $t0,$t3
  mflo $t4
  addi $t5,$zero,4
  mult $t0,$t5
  mflo $t6 
  la $a0,buffer
  add $t1,$t4,$s1
  add $t3,$t6,$s2 
# change number of characters   
  addi $t7,$zero,0
loop2:  add $s0,$a0,$t7
  add $t4,$t1,$t7
  lw $t5,0($s0) # copy name of the player 
  sw $t5,0($t4)
  addi $t7,$t7,4
  addi $t5,$zero,28
  bne $t7,$t5,loop2  
  s.s $f5,0($t3) # save point/min of the player 
  #deallocate the old memory 
  move $a0,$s5 # address of old memory 
  addi $t5,$zero,28
  addi $t6,$s4,-1 
  mult $t6,$t5 
  mflo $t6 
  move $a1, $t6 # number of bytes of old memory
  jal zeroMem
  move $a0,$s6  # address of old memory 
  addi $t5,$zero,4 
  addi $t6,$s4,-1 
  mult $t6,$t5 
  mflo $t6 
  move $a1, $t6 # number of bytes of old memory
  jal zeroMem  
  move $s5,$s1 #update old memory of name 
  move $s6,$s2 #update old memory of point/min 
  j loop_in
first_player:  
  li  $v0,9      # Allocate a block of memory for name array
  li  $a0,28 
  syscall        # $v0 <= address of name array 
  move $s5,$v0 
  li  $v0,9      # Allocate a block of memory for value array 
  li  $a0,4 
  syscall        # $v0 <= address of value array 
  move $s6,$v0   
  #--save data--#
  la $a0,buffer
# change number of characters   
  addi $t7,$zero,0
loop3:  add $s0,$a0,$t7
  add $t4,$s5,$t7
  lw $t5,0($s0) # copy name of the player 
  sw $t5,0($t4)
  addi $t7,$t7,4
  addi $t5,$zero,28
  bne $t7,$t5,loop3 
  s.s $f5,0($s6)
  addi $s4,$s4,1
  j loop_in 
compDone: # Compare the string in address $a0 with "DONE" 
  la $t1, buffer # lower array pointer = array base
  la $t3, done_str
  lb $t4, 0($t1) 
  lb $t5, 0($t3) 
  bne $t4,$t5,loop_i1
  lb $t4, 1($t1) 
  lb $t5, 1($t3) 
  bne $t4,$t5,loop_i1
  lb $t4, 2($t1) 
  lb $t5, 2($t3) 
  bne $t4,$t5,loop_i1
  lb $t4, 3($t1) 
  lb $t5, 3($t3) 
  bne $t4,$t5,loop_i1  
  la $a0,newline
  li $v0, 4 # print string
  syscall # do it 
  addi $t0,$zero,1
  beq $s4,$t0,print_one
  # DONE ACCEPTING PLAYER's DATA
  # Continue on sorting  
 move  $t0, $s6      # Copy the base address of point/min memory 
 addi $t4,$zero,4 
 addi $t5,$s4,-1
 mult $t5,$t4
 mflo $t5
    add $t0, $t0, $t5    # 4 bytes per data * $s4                               
outterLoop:             # Used to determine when we are done iterating over the Array
    add $t1, $0, $0     # $t1 holds a flag to determine when the list is sorted
    move  $a0, $s6      # Set $a0 to the base address of the Array
 move $a1,$s5 
innerLoop:                  # The inner loop will iterate over the Array checking if a swap is needed
    l.s  $f2, 0($a0)         # sets $f2 to the current element in array
    l.s  $f3, 4($a0)         # sets $f3 to the next element in array
 c.lt.s $f2, $f3
 bc1f continue
    add $t1, $0, 1          # if we need to swap, we need to check the list again
 #SWAP point/min and player's name 
    s.s  $f2, 4($a0)         
    s.s  $f3, 0($a0)   
# change number of characters   
  addi $t7,$zero,0
  addi $t6,$zero,28
loop4:  add $s0,$a1,$t7
  add $t4,$a1,$t6
  lw $t2,0($s0)
  lw $t3,0($t4)
  sw $t2,0($t4)
  sw $t3,0($s0)
  addi $t7,$t7,4
  addi $t6,$t6,4
  addi $t5,$zero,28
  bne $t7,$t5,loop4  
continue:
    addi $a0, $a0, 4            # advance the array to start at the next location from last time
 addi $a1, $a1, 28 
    bne  $a0, $t0, innerLoop    
    bne  $t1, $0, outterLoop    # $t1 = 1, another pass is needed, jump back to outterLoop
#---print data OUT-----#
printOut:    move $a2,$s6 
      move $a3,$s5
      addi $t4,$zero,4 
      multu $s4,$t4
      mflo $t5
      move $a1,$t5
               beq        $a1, $zero, endPrint        # if length == 0, branch to endPrint
               addi        $s0, $a2, 0                       
               addi        $s1, $a1, 0                        
      addi   $s3,$a3,0
               addi        $t0, $zero, 0                        # t0 = 0
      addi        $t7, $zero, 0                        # t7 = 0
printLoop:      # PRINT NAME AND  POINT/MIN
    # print name 
    addi $t3, $zero, 0 
    add $s7,$s3,$t7 # increase the index of players
       #li $v0, 4 # print characters
    #move $a0,$s7
       #syscall # do it 
    # print byte by byte 
    move $t2,$s7 
print_loop1: add $t2,$s7,$t3
    lb $t6,0($t2)
    addi $t4,$t6,-10
    beqz $t4, print_next
       li $v0, 11 # print character
    move $a0,$t6
       syscall # do it 
    addi $t3,$t3,1
    addi $t4,$zero,28
    bne $t3,$t4,print_loop1
      # print point/min 
print_next:    li $v0, 4 
     la $a0,blank_text
     syscall 
    add        $t1, $s0, $t0                        
               l.s        $f12, 0($t1)                        
      li $v0,2
      syscall 
               li        $v0, 4                        # v0 = 4
               la        $a0, newline                      
               syscall    
      addi        $t7, $t7, 28
               addi        $s1, $s1, -4                        # s1 = s1 -4
               addi        $t0, $t0, 4                        # t0 = t0 + 4 (next element)
      
               bne        $t0, $t5, printLoop                # if s1 != 0, branch to printLoop

endPrint:      li $v0,4                      # v0 = 4
               la $a0, newline
               syscall                                        # print string "\n"
done1:
    li $v0, 10                # set $v0 = 10 to exit 
    syscall                   # exit    
  
# Deallocate or set zeros to memory 
#  $a0 = address of block of memory
#  $a1 = number of bytes to set to zero
zeroMem:
 beq $a1,$zero,done
 sb $zero,0($a0)
 addiu $a0,$a0,1
 addi $a1,$a1,-1
 j zeroMem
done:
 jr $ra
zero_float:
  mtc1 $zero, $f3 #move to FP registers
  cvt.s.w $f4, $f3
  mov.s $f5,$f3 
  j zero_back
print_one: 
    addi $t3,$zero,0
    move $t2,$s5
    move $s7,$s5
print_loop2: add $t2,$s7,$t3
    lb $t6,0($t2)
    addi $t4,$t6,-10
    beqz $t4, print_next1
       li $v0, 11 # print character
    move $a0,$t6
       syscall # do it 
    addi $t3,$t3,1
    addi $t4,$zero,28
    bne $t3,$t4,print_loop2
print_next1: li $v0, 4 
       la $a0,blank_text
    syscall        
               l.s        $f12, 0($s6)        # print point/min                 
      li $v0,2
      syscall 
               li        $v0, 4                        # v0 = 4
               la        $a0, newline                      
               syscall        
        li $v0, 10                # set $v0 = 10 to exit 
    syscall                   # exit