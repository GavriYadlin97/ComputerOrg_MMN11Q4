
.globl sort
.data
	countARR: .space 64 

.text
	############################## sort ##############################
	# Input	 $a1 address of NUM
	#	 $a2 number of pairs (from $a3)
	# Output: NUM sorted
	# Algorithm: Counting sort
sort:
	li $a3, 0		# Set $a3 = 0
	move $a0, $a1		# Make copy of address of NUM into $a0
count:	
	lb $t8, 0($a1)		# Get number from NUM
	
	la $t0, countARR	# Load address of countARR
	add $t0, $t0, $t8	# Adjust address of countARR for location of the relevent cell
	lb $t9, 0($t0)		# Get current count of items of the same value
	addi $t9, $t9, 1	# Add 1 to count
	sb $t9, 0($t0)		# Store to cell
	
	addi, $a1, $a1, 1	# Move to next char
	addi $a3, $a3, 1	# Count number
	bne $a3, $a2, count	# Loop to count
	
	la $t0, countARR	# Load address of countARR
	la $t1, countARR	# Load address of countARR
place:	
	lb $t9, 0($t1)		# Get current count of item of the same value
	beq $t9, $zero, nextSRT # If count == 0 move to prev cell in countARR
	sub $t8, $t1, $t0	# Get the countARR cell adjustment
insert:
	sb $t8, 0($a0)		# Store the adjustment val into NUM
	addi $a0, $a0, 1	# Move to next cell in NUM
	addi $t9, $t9, -1	# reduce one from count of items of the same value
	bne $t9, $zero, insert	# While count is not zero goto insert
	addi $a2, $a2, -1
nextSRT:
	addi $t1, $t1, 1	# Move to prev cell in countARR
	bne $a2, $zero, place	# While not all values inserted goto place
	
	jr $ra			# Return to caller
	################################################################### 