.text

REVERSE:
	# Reverse reverses an array without creating a new one
	# a0 must be the pointer to first element of array
	# a1 must be the size of array
	add $t0, $zero, $a0 # We call t0 the "begin"
	add $t1, $zero, $a1 # Store a1 in t1
	sll $t1, $t1, 2 # Now we have the byte count of array
	add $t1, $t1, $t0 # Now we call this the "end"
REVERSE_LOOP:
	# We have to loop while begin < end
	slt $t2, $t0, $t1
	bne $t2, $zero, REVERSE_END # End of the loop and function
	# Swap the begin and end
	lw $t2, 0($t0) # Load begin
	lw $t3, 0($t1) # Load end
	# Swap them
	sw $t2, 0($t1) # Save begin
	sw $t3, 0($t0) # Save end
	# Move the pointers (end and begin)
	addi $t0, $t0, 4
	addi $t1, $t1, -4
	j REVERSE_LOOP
	
REVERSE_END:
	jr $ra