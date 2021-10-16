.text
	# Get the x from user
	addi $v0, $zero, 5
	syscall
	# Save it in x
	la $t0, x
	sw $v0, 0($t0)
	# Get n from user
	addi $v0, $zero, 5
	syscall
	# Add
	add $a0, $zero, $v0
	jal F
	# Print the result
	add $a0, $zero, $v0 # v0 is the result of function
	addi $v0, $zero, 1
	syscall
	# Terminate
	addi $v0, $zero, 10
	syscall
	
F:
	# a0 must be equal to the N
	# Result will be in v0
	# Very temp value for comparison
	addi $t0, $zero, 1
	beq $a0, $t0, F_1 # n == 1
	addi $t0, $zero, 2
	beq $a0, $t0, F_2 # n == 2
	# Now the "fun" begins
	# We are going to make some function calls; So store the ra in stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# We also store the N in stack
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	# Now we have to recursively call F with N-1
	# a0 is still valid here
	addi $a0, $a0, -1 # Store N-1 in a0
	jal F # Recursively call F(N-1)
	# Now we get the N from stack and store the result of F(N-1) in stack instead of it
	lw $a0, 0($sp) # Load the N in a0
	sw $v0, 0($sp) # Save the result of F(N-1) in stack
	# Now get ready to call F(N-2)
	addi $a0, $a0, -2 # N-2
	jal F # Recursively call F(N-1)
	# Now calculate the result
	la $t0, x
	lw $t0, 0($t0)
	addi $t0, $t0, -1 # Now we have x-1 in t0
	mul $t0, $t0, $v0 # (x-1)*F(n-2)
	# Load the F(n-1)
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	# Add them
	add $v0, $t0, $t1
	# Load the return address
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	# Return from F
	jr $ra
	
F_1:
	# Return 2
	addi $v0, $zero, 2
	jr $ra
	
F_2:
	# Load x
	la $t0, x
	lw $t0, 0($t0)
	# Dumb thing to do, but I don't want to use the mul
	addi $v0, $zero, 5
	add $v0, $v0, $t0 # 1
	add $v0, $v0, $t0 # 2
	add $v0, $v0, $t0 # 3
	jr $ra

.data
x: .space 4