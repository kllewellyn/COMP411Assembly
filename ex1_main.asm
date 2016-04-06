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