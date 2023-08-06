
.globl print
.globl is_valid
.globl convert

.data
	spaceMSG: .asciiz " "
	newLine: .asciiz "\n"


.text
	############################## print ##############################
	# Input	 $a1 address of NUM
	#	 $a2 number of pairs (from $v0)
	# Output: N/A
print:
	la $a0, newLine		# Print new line
	li $v0, 4		#
	syscall			#
loopPrnt:
	lb $a0, 0($a1)
	li $v0, 1
	syscall
	
	la $a0, spaceMSG	# Print space
	li $v0, 4		#
	syscall			#
	
	addi $a1, $a1, 1	# Move to next byte in NUM
	addi $a2, $a2, -1	# Count print
	bne $a2, $zero, loopPrnt	# Next loop
	
	la $a0, newLine		# Print new line
	li $v0, 4		#
	syscall			#
	
	jr $ra			# Return to caller
	################################################################### 

	
	############################## convert ##############################
	# Input: $a0 address of stringocta
	#	 $a1 address of NUM
	#	 $a2 number of pairs (from $v0)
	# Output: assignment of values in NUM
convert:
	lb $t0, 0($a0)		# Get first digit into $t0
	lb $t1, 1($a0)		# Get second digit into $t0
	
	li $t9, '0'		# Set $t9 to minus val of '0'
	sub $t9, $zero, $t9	#
	
	add $t0, $t0, $t9	# Set $t0 to the acctual value of the digit
	add $t1, $t1, $t9	# Set $t0 to the acctual value of the digit
	
	sll $t0, $t0, 3		# Shift $t0 3 times left, i.e mul by base 8
	add $t0, $t0, $t1	# Sum 8*$t0+$t1 = number in deci
	
	sb $t0, 0($a1)		# Store the resault in NUM
	
	addi $a0, $a0, 3	# Move to next block in stringocta
	addi $a1, $a1, 1	# Move to next byte in NUM
	addi $a2, $a2, -1	# Count pait
	bne $a2, $zero, convert	# Next loop
	
	jr $ra			#return to caller
	
	#####################################################################


	############################## is_valid #########################
	# Input: $a0: address of stringocta
	# Output: number of pairs in a string format: 00$00$...00$ (0 is any digit between 0 and 7)
	# Outputs 0 if invalid
	
is_valid:
	li $t8, 0		# Char counter				# Prepare base parameters
	li $t9, 0		# Digit sequence counter		#
	li $v0, 0		# Return value				#
loop_is_valid:	
	lb $t0, 0($a0)		# Get single char into $t0
	
	beq $t0, '\n', last	# If encountered '\n' finish.		# Check the end of input (that ends with '$')
	beq $t0, '\0', last	# If encountered '\0' finish.		#
validate:
	bne $t0, '$', checkDig	# If char != '$' goto checkDig		# Check if the char is a '$'
	bne $t9, 2, bad		# If sequence isn't equal to two (pair) goto bad
	addi $v0, $v0, 1	# Count a pair into return value	#
	li $t9, 0		# Reset digit sequence counter		#
	j next
checkDig:	
	slti $t1, $t0, '0'	# If char < '0' set $t1 to 1, else to 0
	sgt $t2, $t0, '7'	# If char > '7' set $t2 to 1, else to 0	
	bne $t1, $t2, bad	# Either '0' <= char <= '7' and $t1 = $t2 = 0 or $t1 != $t2 , if not equal goto bad
	addi $t9, $t9, 1	# Count digit in sequence	
next:
	addi $a0, $a0, 1	# Move to next char			# Prepare for next cycle
	addi $t8, $t8, 1	# Count char				#
	bgt $t8, 30, bad	# Check length of input			#
	j loop_is_valid		# Goto loop
last:	
	lb $t3, -1($a0)		# Load prior to last char
	beq $t3, '$', return	# If char is '$' finish
bad:
	li $v0, 0		# Set $v0 for bad input return val
return:
	jr $ra			# Return to caller
	##################################################################
	
