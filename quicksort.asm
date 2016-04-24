.data 0x0

newLine:  .asciiz "\n"

.text 0x3000
.globl main
main:

	addiu	$v0, $0, 5	#gets the number of items that need to be sorted
	syscall
	move	$a2, $v0	#stores number of ints into $a2
	sll	$v0, $t0, 2	# multiplies ints by 4 for number of bytes
	move	$a0, $v0 	#move the number of ints into $a0 to allocate space
	
	addiu	$v0, $0, 9	#allocates appropriate number of bytes to array
	syscall
	
	move	$a1, $v0	#moves address of array into $a1
	move	$a3, $a1	#keep copy of original address in $a3
	li	$t0, 0		#sets $t0 to 0

loop: 	beq	$t0, $a2, letitsort	#if the number of items input reaches size
	
	addiu	$v0, $0, 5	#gets the int input
	syscall
	
	sb	$v0, ($a1)	#stores the input into address in $a1
	addiu	$t0, $t0, 1	#increment $t0 by one
	sll	$t1, $t0, 2
	add	$a1, $t1, $a1
	
	j	loop

letitsort: 
	move	$a0, $a3	#original address of array in $a0
	li	$a1, 0		#start index = 0
	subiu	$a2, $a2, 1	#end index = size - 1
	li	$v0, 0		#zero out $v0 register
	li	$t0, 0
	jal	quicksort

loop1:
	
	beq	$a2, $t0, exit_from_main
	move	$t3, $v0
	sll	$t1, $t0, 2
	add	$t2, $t1, $t3
	lb	$a0, ($t2)
	li	$v0, 1	#prints sorted quicksort numbers
	syscall
	
	la	$a0, newLine	#prints newLine
	addiu	$v0, $0, 4
	syscall
	
	addiu	$t0, $t0, 1
	
	j	loop1
	
	
exit_from_main:
ori     $v0, $0, 10     # System call code 10 for exit
syscall                 # Exit the program
end_of_main:


.globl 	quicksort

quicksort:

addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
sw  $ra, 4($sp)             # Save $ra
sw  $fp, 0($sp)             # Save $fp

addiu   $fp, $sp, 4         # Set $fp to the start of proc1's stack frame


#body of sort
	move	$s0, $a0	#move location of data address into $s0

	move	$s1, $a1	#(first int index)
	move	$s2, $a2	#last int index)	
	move	$t2, $s1	#move first index loc into $t2
	move	$t3, $s2
	move	$v0, $s0
	bge  	$s1, $s2, return_from_quicksort #exit loop if first index >= last index
	
	sll	$t6, $t2, 2
	sll	$t7, $t3, 2
	add	$t0, $s0, $t6
	add	$t1, $s0, $t7
	
	lb	$s3, ($t0)	#load int at first index
	lb	$s4, ($t1)	#load int at last index
	move	$s5, $s3	#set pivot as int in first index
	
outerloop:	
	bge	$t2, $t3, pivotswap	#outer while loop
innerloop1:	
	bgt  	$s3, $s5, lastLoop	#if first element go to next loop
	beq	$s2, $t1, lastLoop
	addiu	$t2, $t2, 1
	sll	$t6, $t2, 2
	add	$t0, $s0, $t6
	lb	$s3, ($t0)
	j	innerloop1
lastLoop:
	beq	$s4, $s5, lastIf
	subiu	$t3, $t3, 1
	sll	$t7, $t3, 2
	add	$t1, $s0, $t7
	lb	$s4, ($t1)	
	j	lastLoop
lastIf:
	beq	$t2, $t3, pivotswap
	
	sll	$t6, $t2, 2
	add	$t0, $s0, $t6
	lb	$s3, ($t0)
	
	sll	$t7, $t3, 2
	add	$t1, $s0, $t7
	lb	$s4, ($t1)
	
	sb	$s4, ($t0)
	sb	$s3, ($t1)
	j	outerloop	
	
pivotswap:	
	sll	$t6, $s2, 2
	add	$t0, $s0, $t6
	
	sll	$t7, $t3, 2
	add	$t1, $s0, $t7
	lb	$s4, ($t1)
	sb	$s4, ($t0)
	sb	$s5, ($t1)

	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $t3
	subiu	$a2, $a2, 1
	move	$v0, $a0
	jal	quicksort
	
	move	$a0, $s0
	move	$a1, $t3
	addiu	$a1, $a1, 1
	move	$a2, $s2
	move	$v0, $a0
	jal	quicksort
	
return_from_quicksort:
lw  $ra, 0($fp)             # Restore $ra
lw  $fp, -4($fp)            # Restore $fp
addiu   $sp, $sp, 8       # Restore $sp
jr  $ra                     # Return from procedure
	
	
end_of_quicksort:
