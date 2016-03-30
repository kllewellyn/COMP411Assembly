# =============================================================
# PROCEDURE WRITING WORKSHEET
#
# How many arguments does this procedure expect?
#
# Where are they going to be?  The first four should be in
#   register $a0-$a3, rest on the stack
#       8($fp) --> arg[5]'s value
#       4($fp) --> arg[4]'s value
#       etc.
#
# Write the code for the body of this procedure first,
#   without worrying much about saving/restoring values
#   on/from the stack
#
# Which registers out of $s0-$s7 does this procedure modify?
#
# Which registers out of $t0-$t9, $a0-$a3, and $v0-$v1 must
#   be protected from a call to a callee?
#
# Which local variables are needed to be created?
#
# What is the max number of arguments this procedure will need
#   for calling *any* callee?
#
# Now, complete your code using the template below
#
# =============================================================

.globl main

main:	syscall 8 
	


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

a_to_i:   beqz $a0, return_from_proc1
	subu $a0, $a0, 48 
	mult $s0, 10
	add $s0, $s0, lo
	add $s0, $a0, $s0
	add $v0, $s0, $0




        # =====================================================
        # proc1 CALLS proc2
        #
        # Suppose proc1 needs to call proc2, and protect 
        #   $t0 and $t1 during this call.  Suppose there are six
        #   arguments to send to proc2(0,10,20,30,40,50).
        # Here's how to do it.
        # The same technique applies to protecting any of
        #   $t0-$t9, $a0-$a3, and $v0-$v1.

        sw  $t0, -24($fp)           # Save $t0
        sw  $t1, -28($fp)           # Save $t1
        
        ori $a0, $0, 50             # Put 50 in ...
        sw  $a0, 4($sp)             # ... arg[5]
        ori $a0, $0, 40             # Put 40 in ...
        sw  $a0, 0($sp)             # ... arg[4]

        ori $a0, $0,  0             # Put  0 in $a0
        ori $a1, $0, 10             # Put 10 in $a1
        ori $a2, $0, 20             # Put 20 in $a2
        ori $a3, $0, 30             # Put 30 in $a3

        jal proc2

        lw  $t0, -24($fp)           # Restore $t0
        lw  $t1, -28($fp)           # Restore $t1
        
        
        
        
        

        # =====================================================

# ...
# ...
# put return values, if any, in $v0-$v1
# END OF BODY OF proc1
# =============================================================



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
