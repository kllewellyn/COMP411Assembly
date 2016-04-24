.data 0x0

newLine:  .asciiz "\n"

.text 0x3000
.globl main
main:

	addiu	$v0, $0, 5	#gets the number of items that need to be sorted
	syscall
	sll	$v0, $v0, 2	# multiplies ints by 4 for number of bytes
	move	$a0, $v0 	#move the number of ints into $a0 to allocate space
	move	$a2, $a0	#moves the size of array into $a2
	addiu	$v0, $0, 9	#allocates appropriate number of bytes to array
	syscall
	
	move	$a1, $v0	#moves address of array into $a1
	li	$t0, 0		#sets $t0 to 0

loop: 	beq	$t0, $a1, letitsort
	addiu	$t0, $t0, 1
	
	addiu	$v0, $0, 5	#gets the int input
	syscall
	
	sb	$v0, ($a1)	#stores the input into address in $a1
	j	loop
	
	
#	move	$a0, $v0 #move parsed int into register
#	addiu	$v0, $0, 0 #zero out the $v0 register
	
letitsort: jal	quicksort

loop1:
	li	$t0, 0
	beq	$a2, $t0, exit_from_main
	lb	$a0, ($a1)
	li	$v0, 1	#prints sorted quicksort numbers
	syscall
	
	la	$a0, newLine	#prints newLine
	addiu	$v0, $0, 4
	syscall
	
	j	loop1
	
	
exit_from_main:
ori     $v0, $0, 10     # System call code 10 for exit
syscall                 # Exit the program
end_of_main:


.globl 	quickSort

quicksort:

addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
sw  $ra, 4($sp)             # Save $ra
sw  $fp, 0($sp)             # Save $fp

addiu   $fp, $sp, 4         # Set $fp to the start of proc1's stack frame


#body of sort
	lb	$s0, #(first int index)
	lb	$s1, #last int index)	
	bge  	$s0, $s1, return_from_quicksort #exit loop 
						#if first index >= last index
	li	$t0, 1	#increment value
	srlv 	$t0, $t0, $s1	#location of the int at last index
	lb	$t1, 1
	sllv	$t1, $t1, $s0	#location of the int at first index
	
	lb	$s2, 		#load int at first index
	lb	$s3,		#load int at last index
	move	$s4, $s2	#set pivot as int in first index
	
	move	$t2, $s0
	move	$t3, $s1
	
loop3:	bge	$t2, $t3, pivotswap
	
	
	

pivotswap:	



return_from_quicksort:
lw  $ra, 0($fp)             # Restore $ra
lw  $fp, -4($fp)            # Restore $fp
addiu   $sp, $sp, 8       # Restore $sp
jr  $ra                     # Return from procedure
	
	
end_of_quicksort: