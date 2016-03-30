# Add the numbers in an array

.data 0x0
sum:    .space 4
i:      .space 4
a:      .word 7,8,9,10,8

.text 0x3000
.globl main
main:
     sw    $0, 0($0)       # sum = 0;
     sw    $0, 4($0)       # for (i = 0;
     lw    $9, 4($0)       # allocate register for i
     lw    $8, 0($0)       # choose register $8 to hold value for sum
loop:
     sll   $10, $9, 2     # covert "i" to word offset
     lw    $10, 8($10)   # load a[i]
     add   $8, $8, $10    # sum = sum + a[i];
     sw    $8, 0($0)       # update variable in memory
     addi  $9, $9, 1      # for (...; ...; i++
     sw    $9, 4($0)         # update memory
     slti  $10, $9, 5     # for (...; i<5;
     bne   $10, $0, loop
end: 
     ori   $v0, $0, 10     # system call 10 for exit
     syscall               # we are out of here.