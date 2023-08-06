  
.data
	welcomeMSG: .asciiz "Hello\nPlease enter a Series of chars (up to 30 chars long)\nin the following format: \"00$00$...00$\"\nWhere each 0 is a digit between 0 and 7 only:\n"
	errMSG: .asciiz "\n\nBad input!\nPlease try again!\n\n"
	sortedMSG: "\nSorted:\n"
	stringocta: .space 31
	NUM: .space 10	
.text

.globl main
main:
	jal run	
exit:	
	li $v0, 10		# Exit
	syscall			#
	######################### run #########################
	# Input:  N/A
	# Output: N/A
	# Contains the main logic	
run:	
	addi $sp, $sp, -4	# Push main return address to stack
	sw $ra, 0($sp)		#
	
	la $a0, welcomeMSG	# Welcome
	li $v0, 4		#
	syscall			#
	
	la $a0, stringocta	# Uset input
	li $a1, 31		#
	li $v0,8 		#
	syscall			#
	
	jal is_valid		# Call is_valid
	beq $v0, $zero, retry	# If bad input restart
	
	move $s1, $v0		# Save a copy of $v0 AKA is_valid result
	
	la $a0, stringocta	# Call convert
	la $a1, NUM		#
	move $a2, $s1		#
	jal convert		#
	
	la $a1, NUM		# Call print
	move $a2, $s1		#
	jal print		#
	
	la $a1, NUM		# Call sort
	move $a2, $s1		#
	jal sort		#
	
	la $a0, sortedMSG	# Sorted
	li $v0, 4		#
	syscall			#
	
	la $a1, NUM		# Call print
	move $a2, $s1		#
	jal print		#
	
	lw $ra, 0($sp)		# Pull main return address to stack
	addi, $sp, $sp, 4	#
	
	jr $ra			# Return to caller
	##################################################
	
retry:
	la $a0, errMSG		# Bad input, show error msg and restart
	li $v0, 4		#
	syscall			#
	j run			#
