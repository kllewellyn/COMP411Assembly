
#Kaylee Llewellyn


.data 0x0
	magicNumber:	.asciiz	"P2"
	space:	.asciiz	"\n"
	
	
i: .space 4
.text 0x3000

main:
	ori $v0, $0, 4				#System call code 4 for printing a string
	ori $a0, $0, 0x0   	 		#address of startString is in $a0
	syscall	


loop:
	


	la $a0, space
	addi $v0, $0, 4
	syscall
	
	