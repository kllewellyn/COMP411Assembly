.data 0x0
#
# global variables here
newLine:  .asciiz "\n"

.text 0x3000
.globl main

main:

ori     $sp, $0, 0x2ffc     # Initialize stack pointer to the top word below .text
                            # The first value on stack will actually go at 0x2ff8
                            #   because $sp is decremented first.
addi    $fp, $sp, -4        # Set $fp to the start of main's stack frame



loop: 	addiu	$v0, $0, 5
	syscall
	
	move	$a0, $v0 #move parsed int into register
	addiu	$v0, $0, 0 #zero out the $v0 register
	
	jal	fibonacchi
	move	$t0, $v0
	move	$a0, $t0
	
	li	$v0, 1	#prints fibonacchi number
	syscall
	
	la	$a0, newLine
	addiu	$v0, $0, 4
	syscall

	beq	$t0, $0, exit_from_main
	j	loop
	
	
exit_from_main:
ori     $v0, $0, 10     # System call code 10 for exit
syscall                 # Exit the program
end_of_main:


.globl fibonacchi

fibonacchi:
addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
sw  $ra, 4($sp)             # Save $ra
sw  $fp, 0($sp)             # Save $fp

addiu   $fp, $sp, 4         # Set $fp to the start of proc1's stack frame


        
                #   procedure call from proc1 to another procedure (e.g., proc2)

		move $s0, $a0
		beqz $s0, zero
		beq  $s0, 1, one
		
		addi $sp, $sp, -4
		sw   $s0, 0($sp)
		
		subi $s0, $s0, 1 #minus 1 from $s0
		move $a0, $s0
		jal	fibonacchi
		
		lw   $s0, 0($sp)
		addi $sp, $sp, 4
		
		subi $s0, $s0, 2 #subtract 1 from $s0 again
		move $a0, $s0
		jal	fibonacchi
		
		j	return_from_fibonacci
		
		
zero:	addiu $v0, $v0, 0
	j	return_from_fibonacci
	
one:	addiu $v0, $v0, 1
	j	return_from_fibonacci
	
	
return_from_fibonacci:
lw  $ra, 0($fp)             # Restore $ra
lw  $fp, -4($fp)            # Restore $fp
addiu   $sp, $sp, 8       # Restore $sp
jr  $ra                     # Return from procedure
	
	
end_of_fibonacci:	
