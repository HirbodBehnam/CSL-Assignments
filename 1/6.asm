.text
	addi $a0, $zero, 100
	jal DIVISORS
	add $t0, $zero, $v0
	# Print first 3 divisors
	addi $v0, $zero, 1
	lw $a0, 0($t0)
	syscall
	lw $a0, 4($t0)
	syscall
	lw $a0, 8($t0)
	syscall
	# Terminate
	addi $v0, $zero, 10
	syscall
	
DIVISORS:
	# The number must be in a0
	# The v0 will be the pointer to start of array of results
	# At first we count the number of divisors
	sw $ra, 0($sp) # Save return address in stack
	addi $sp, $sp, -4 # Move the stack pointer
	sw $a0, 0($sp) # Save N address in stack
	addi $sp, $sp, -4 # Move the stack pointer
	# Call the function to get the count of divisors
	jal DIVISOR_COUNT
	# Pop the stack
	addi $sp, $sp, 4 # Move the stack pointer
	lw $t0, 0($sp) # Load the N in t0 NOT a0
	addi $sp, $sp, 4 # Move the stack pointer
	lw $ra, 0($sp) # Load the return address
	# Now we create an array using the syscall
	sll $a0, $v0, 2 # Number of divisors * 4 = bytes we need to allocate
	addi $v0, $zero, 9
	syscall
	# Now v0 contains the memory address of array
	addi $t1, $zero, 2 # This is our loop counter
	add $t2, $zero, $v0 # This is our memory offset to store numbers in it
DIVISOR_LOOP:
	sgt $t3, $t1, $t0 # If i > n Then set t3 = 1
	bne $t3, $zero, DIVISOR_DONE # End
	div $t0, $t1 # Divide
	mfhi $t3 # Get the mod
	bne $t3, $zero, DIVISOR_LOOP_END # If the mod is non zero, go the the end of loop
	# Store in the array
	sw $t1, 0($t2)
	addi $t2, $t2, 4 # Move the array pointer
DIVISOR_LOOP_END:
	addi $t1, $t1, 2 # Increase the loop index
	j DIVISOR_LOOP # Loop
DIVISOR_DONE:
	jr $ra # Done
	
DIVISOR_COUNT:
	# Counts the number of divosors. The number is in a0
	# a0 is not touched
	# The result will be returned in v0
	addi $v0, $zero, 0 # In v0 we store the count of divisors
	addi $t0, $zero, 2 # In t0 we store the index of loop; We start from 2 and go up 2 by 2
DIVISOR_COUNT_LOOP:
	sgt $t1, $t0, $a0 # If i > n Then set t2 = 1
	bne $t1, $zero, DIVISOR_COUNT_DONE # End
	div $a0, $t0 # Divide
	mfhi $t1 # Get the mod
	bne $t1, $zero, DIVISOR_COUNT_LOOP_END # If the mod is non zero, go the the end of loop
	# Otherwise add one to counter
	addi $v0, $v0, 1
DIVISOR_COUNT_LOOP_END:
	addi $t0, $t0, 2 # Increase the loop index
	j DIVISOR_COUNT_LOOP # Loop
DIVISOR_COUNT_DONE:
	jr $ra # Return
	
