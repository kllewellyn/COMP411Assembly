.data 0x0

input: .space 20
newLine:  .asciiz "\n"
     

.text 0x3000
.globl main

main:

ori     $sp, $0, 0x2ffc     # Initialize stack pointer to the top word below .text
                            # The first value on stack will actually go at 0x2ff8
                            #   because $sp is decremented first.
addi    $fp, $sp, -4        # Set $fp to the start of main's stack frame



# =============================================================
# Create room for temporaries to be protected
addi    $sp, $sp, -8        # Make room on stack for saving any of the following registers
                            #   whose values are precious, and must survive a
                            #   procedure call from main to another procedure (e.g., proc1).
                            # These registers are $t0-$t9, $a0-$a3, and $v0-$v1.
                            # We do not save their values yet; values are saved right
                            #   before calling the other procedure, and restore upon return.

                            # For example, say we need to protect $t0 and $t1
                            #   during a call to proc1.  So, we allocate 2 words on stack.
                            # From now on:
                            #    0($fp) --> $t0's saved value
                            #   -4($fp) --> $11's saved value
# =============================================================



# =============================================================
# Create local variables on stack
                            # Put local variables on the stack.
addi    $sp, $sp, -16       # e.g., int i, j, k, l
sw  $0, 12($sp)             # Set i=0, or skip initialization
sw  $0, 8($sp)              # j=0
sw  $0, 4($sp)              # k=0
sw  $0, 0($sp)              # l=0

                            # From now on:
                            #    -8($fp) --> i's value
                            #   -12($fp) --> j's value
                            #   -16($fp) --> k's value
                            #   -20($fp) --> l's value
# =============================================================



# =============================================================
# Make room for spillover arguments (beyond the first four),
# which are needed to call, say, proc1
                            # Make room for arg[4] and arg[5]
addi    $sp, $sp, -8        # e.g., main will call proc1 with 6 arguments
sw  $0, 4($sp)              # arg[5]=0, or skip initialization
sw  $0, 0($sp)              # arg[4]=0

                            # From now on:
                            #   -24($fp) --> arg[5]'s value
                            #   -28($fp) --> arg[4]'s value
                            # Alternatively:
                            #   4($sp) --> arg[5]'s value
                            #   0($sp) --> arg[4]'s value
                            #
                            # But, after proc1 adjusts $fp, it will access these as:
                            #   8($fp) --> arg[5]'s value
                            #   4($fp) --> arg[4]'s value
                            # etc.
# =============================================================


# BODY OF main
loop:
		addiu $v0, $0, 8
		addiu $a1, $0, 21
		la    $a0, input
		syscall
		jal	proc1
		add   $a0, $v0, $0
		addiu $v0, $0, 1
		syscall
		beq   $a0, $0, exit_from_main
		la     $a0, newLine
    		 addi   $v0, $0, 4
    		 syscall
		j loop
	
exit_from_main:
ori     $v0, $0, 10     # System call code 10 for exit
syscall                 # Exit the program
end_of_main:


.globl proc1

proc1:
addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
sw  $ra, 4($sp)             # Save $ra
sw  $fp, 0($sp)             # Save $fp

addiu   $fp, $sp, 4         # Set $fp to the start of proc1's stack frame

                            # From now on:
                            #     0($fp) --> $ra's saved value
                            #    -4($fp) --> caller's $fp's saved value
                

# =============================================================
# Save any $sx registers that proc1 will modify
                            # Save any of the $sx registers that proc1 modifies
addi    $sp, $sp, -16       # e.g., $s0, $s1, $s2, $s3
sw  $s0, 12($sp)            # Save $s0
sw  $s1, 8($sp)             # Save $s1
sw  $s2, 4($sp)             # Save $s2
sw  $s3, 0($sp)             # Save $s3

                            # From now on:
                            #    -8($fp) --> $s0's saved value
                            #   -12($fp) --> $s1's saved value
                            #   -16($fp) --> $s2's saved value
                            #   -20($fp) --> $s3's saved value
# =============================================================



# =============================================================
# Create room for temporaries to be protected
addi    $sp, $sp, -8        # Make room on stack for saving any of the following registers
                            #   whose values are precious, and must survive a
                            #   procedure call from proc1 to another procedure (e.g., proc2).
                            # These registers are $t0-$t9, $a0-$a3, and $v0-$v1.
                            # We do not save their values yet; values are saved right
                            #   before calling the other procedure, and restore upon return.

                            # For example, say we need to protect $t0 and $t1
                            #   during a call to proc2.  So, we allocate 2 words on stack.
                            # From now on:
                            #   -24($fp) --> $t0's saved value
                            #   -28($fp) --> $11's saved value
# =============================================================



# =============================================================
# Create local variables on stack
                            # Put local variables on the stack.
addi    $sp, $sp, -16       # e.g., int i, j, k, l
sw  $0, 12($sp)             # Set i=0, or skip initialization
sw  $0, 8($sp)              # j=0
sw  $0, 4($sp)              # k=0
sw  $0, 0($sp)              # l=0

                            # From now on:
                            #   -32($fp) --> i's value
                            #   -36($fp) --> j's value
                            #   -40($fp) --> k's value
                            #   -44($fp) --> l's value
# =============================================================



# =============================================================
# Make room for spillover arguments (beyond the first four),
# which are needed to call, say, proc2
                            # Make room for arg[4] and arg[5]
addi    $sp, $sp, -8        # e.g., proc1 will call proc2 with 6 arguments
sw  $0, 4($sp)              # arg[5]=0, or skip initialization
sw  $0, 0($sp)              # arg[4]=0

                            # From now on:
                            #   -48($fp) --> arg[5]'s value
                            #   -52($fp) --> arg[4]'s value
                            # Alternatively:
                            #   4($sp) --> arg[5]'s value
                            #   0($sp) --> arg[4]'s value
                            #
                            # But, after proc2 adjusts $fp, it will access these as:
                            #   8($fp) --> arg[5]'s value
                            #   4($fp) --> arg[4]'s value
                            # etc.
# =============================================================



# =============================================================
# BODY OF proc1
# ...
# ...

a_to_i:   


	  addiu $a0, $a0, 0
	  lb $s0, input($t2)
	 
	  beq $s0, 10, return_from_proc1
	  addiu $t2, $t2, 1
	  addiu $s4, $s4, 0
	  addi  $s4, $s4, 48 
	  sub   $s0, $s0, $s4
	  add  $s1, $0, 10
	  multu $s3, $s1
	  mflo $s2
	  add $a0, $0, $s2
	  add $a0, $a0, $s0
	  add $v0, $a0, $0
	  j a_to_i


# =============================================================
# Restore $sx registers
lw  $s0,  -8($fp)           # Restore $s0
lw  $s1, -12($fp)           # Restore $s1
lw  $s2, -16($fp)           # Restore $s2
lw  $s3, -20($fp)           # Restore $s3
# =============================================================



# =============================================================
# Restore $fp, $ra, and shrink stack back to how we found it,
#   and return to caller.

return_from_proc1:
lw  $ra, 0($fp)             # Restore $ra
lw  $fp, -4($fp)            # Restore $fp
addiu   $sp, $sp, 56        # Restore $sp
jr  $ra                     # Return from procedure
# =============================================================


end_of_proc1:
