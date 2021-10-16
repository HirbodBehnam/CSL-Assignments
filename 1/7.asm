.text
	# Read N
	addi $v0, $zero, 5
	syscall
	# Store N in $t0; We have to use this for our loop
	add $t0, $zero, $v0
	add $s0, $zero, $v0 # We also store it in s0 to store it later in stack (end of loop)
	# Now we have to read N bytes from input
READ_LOOP:
	beq $t0, $zero, READ_DONE # If we have read everything, go to done
	# Read number
	addi $v0, $zero, 5
	syscall
	# Store in stack
	addi $sp, $sp, -4 # Move the stack pointer
	sw $v0, 0($sp) # Store it in stack
	addi $t0, $t0, -1 # We have read one number
	j READ_LOOP # Loop
READ_DONE:
	# Store N in stack
	addi $sp, $sp, -4 # Move the stack pointer
	sw $s0, 0($sp) # Store it in stack
	# Now load N
	lw $t0, 0($sp)
	# We store the pointer to first location of our array in t1
	# The pointer is stack pointer + N * 4
	add $t1, $zero, $t0 # Copy t0 in t1 (N)
	sll $t1, $t1, 2 # = N*4
	add $t1, $t1, $sp # Just add the stack pointer
	# Loop
WRITE_LOOP:
	beq $t0, $zero, WRITE_DONE
	# Print
	lw $a0, 0($t1) # Load from temp stack pointer
	addi $v0, $zero, 1
	syscall
	# Move the pointer and add N
	addi $t1, $t1, -4
	addi $t0, $t0, -1
	j WRITE_LOOP
WRITE_DONE:
	# Done