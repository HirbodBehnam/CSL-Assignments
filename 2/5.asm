.text
	jal FUNCTION
	jal FUNCTION
	jal FUNCTION
	addi $v0, $zero, 10
	syscall

FUNCTION:
FUNCTION_INIT_A:
	addi $t0, $zero, 0
	andi $t1, $t0, 1 # This gets the remainder by 2
	beq $t1, $zero, FUNCTION_ADD_3 # Check the remainder
	# If we have reached here it means that we have to calculate the first expression
	# a = a + a / 2
	addi $t1, $zero, 2
	div $t2, $t0, $t1 # a / 2
	add $t0, $t0, $t2 # a = a + a / 2
	j FUNCTION_DONE
FUNCTION_ADD_3:
	addi $t0, $t0, 3 # a = a + 3
FUNCTION_DONE:
	# Now we have to replace the first command with current A
	la $t1, FUNCTION_INIT_A
	lw $t1, 0($t1)
	# Remove the last 16 bytes from instruction which is the immidate part of it
	andi $t1, $t1, -65536 # Same as 11111111 11111111 00000000 00000000
	or $t1, $t1, $t0 # Place the a in the t0
	# Save the instruction
	la $t2, FUNCTION_INIT_A
	sw $t1, 0($t2)
	# Return
	jr $ra
