.text
	addi $a0, $zero, 5
	jal IS_SECOND
	# Print
	add $a0, $zero, $v0
	addi $v0, $zero, 1
	syscall
	# Terminate
	addi $v0, $zero, 10
	syscall

IS_SECOND:
	# Is second checks if a number is a "second number" or not
	# The input of N must be in $a0
	# The output in v0 will be either zero or one
	addi $t0, $zero, 1 # Our loop counter in t0 (i)
IS_SECOND_LOOP:
	beq $t0, $a0, IS_SECOND_DONE_GOOD # If we have reached N, we are good and must return true
	# Check if N % t0 == 0
	div $a0, $t0
	mfhi $t1 # mod now in t1
	beq $t1, $zero, IS_SECOND_CANDIDATE # If mod is zero, check for second number
IS_SECOND_LOOP_CONTINUE:
	addi $t0, $t0, 1 # i++
	j IS_SECOND_LOOP
	
IS_SECOND_CANDIDATE:
	addi $t1, $a0, 1 # t1 = N+1
	addi $t2, $t0, 1 # t2 = i+1
	div $t1, $t2
	mfhi $t1 # mod now in t1
	bne $t1, $zero, IS_SECOND_DONE_BAD # If the mod is not zero, return false
	j IS_SECOND_LOOP_CONTINUE

IS_SECOND_DONE_BAD:
	# Return false
	addi $v0, $zero, 0
	jr $ra

IS_SECOND_DONE_GOOD:
	# Return true
	addi $v0, $zero, 1
	jr $ra