#---------------------------------
# Lab 6: Pixel Conversion
#
# Name: Kaylee Llewellyn
#
# --------------------------------
# Below is the expected output.
# 
# Converting pixels to grayscale:
# 0
# 1
# 2
# 34
# 5
# 67
# 89
# Finished.
# -- program is finished running --
#---------------------------------

.data 0x0
	startString:	.asciiz	"Converting pixels to grayscale:\n"
	finishString:	.asciiz	"Finished."
	newline:	.asciiz	"\n"
	pixels:		.word 	0x00010000,	0x010101,	0x6,		0x3333, 
				0x030c,		0x700853,	0x294999,	-1
sum: .space 4
i: .space 4
.text 0x3000

main:
	ori $v0, $0, 4				#System call code 4 for printing a string
	ori $a0, $0, 0x0   	 		#address of startString is in $a0
	syscall						#print the string


#------- INSERT YOUR CODE HERE -------
	
	sw    $0, sum($0)       # sum = 0;
	sw    $0, i($0)       # for (i = 0;
	lw    $9, i($0)       # allocate register for i
	lw    $7, i($0)
	lw    $8, sum($0)       # choose register $8 to hold value for sum
	li    $6, 0xff
	li    $3, 3
	li    $5, -1	
loop:
     sll   $10, $7, 2
     lw    $12, pixels($10)
     addi  $7,  $7, 1
     beq   $12, $5, exit
     
     li    $8, 0
     and   $11, $12, $6    #get blue
     
     add   $8, $8, $11    # sum = sum + a[i];
     sw    $8, sum($0)       # update variable in memory
     srl   $12, $12, 8
     			     #gets green
     and   $11, $12, $6
     add   $8, $8, $11    # sum = sum + a[i];
     sw    $8, sum($0)      #update variable in memory

     srl   $12, $12, 8    #gets red
     
     and   $11, $12, $6
     add   $8, $8, $11    # sum = sum + a[i];
     sw    $8, sum($0)       # update variable in memory
     
   
     sw    $9, i($0)         # update memory
     
     div    $8, $3 #store 3 in register
    
     mflo  $a0
     
       
     li   $v0, 1
     syscall
     ori $v0, $0, 4				# System call code 4 for printing a string
     ori $a0, $0, 31
     syscall
     

     j    loop


#------------ END CODE ---------------


exit:

	ori $v0, $0, 4				# System call code 4 for printing a string
	ori $a0, $0, 33  			# address of finishString is in $a0; we computed this
								# simply by counting the number of chars in startString,
								# including the \n and the terminating \0

	syscall						#print the string

	ori $v0, $0, 10				#System call code 10 for exit
	syscall						#exit the program
