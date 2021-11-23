.text
	jal READ_NUMBERS # Read the input
	add $s0, $zero, $v0 # Store pointer in s0. Now if subroutines want to change s0, they have to store it in stack
	add $s1, $zero, $v1 # Store N in s1. Same thing above
	# Calculate average
	add $a0, $zero, $s0
	add $a1, $zero, $s1
	jal CALCULATE_AVERAGE
	add $s2, $zero, $v0 # Store the average in s2; See the note above about s registers
	mtc1 $s2, $f12 # Print
	addi $v0, $zero, 2
	syscall
	jal PRINT_NEW_LINE
	# Calculate standard deviation
	add $a0, $zero, $s0
	add $a1, $zero, $s1
	add $a2, $zero, $s2
	jal STANDARD_DEVIATION
	add $s3, $zero, $v0 # Store the standard deviation in s3; See the note above about s registers
	mtc1 $s3, $f12 # Print
	addi $v0, $zero, 2
	syscall
	jal PRINT_NEW_LINE
	# "Standard" the array
	add $a0, $zero, $s0
	add $a1, $zero, $s1
	add $a2, $zero, $s2
	add $a3, $zero, $s3
	jal STANDARD
	# Print the array
	add $a0, $zero, $s0
	add $a1, $zero, $s1
	jal PRINT_ARRAY
	jal PRINT_NEW_LINE
	# Goodbye
	addi $v0, $zero, 10
	syscall

PRINT_NEW_LINE:
	la $a0, newline
	li $v0, 4
	syscall
	jr $ra

READ_NUMBERS:
	# Read numbers gets N from stdin and then reads n float from input
	# It creates an array with starting pointer in v0 and the N in v1
	# At first read N
	addi $v0, $zero, 5
	syscall
	add $t1, $zero, $v0 # Store N in t1
	add $t9, $zero, $zero # Empty t9 for loop counter
	# Allocate memory
	addi $v0, $zero, 9
	sll $a0, $t0, 2 # Allocate N * 4 bytes
	syscall
	add $t0, $zero, $v0 # Copy the memory address to t0
	add $t8, $zero, $v0 # Also make a copy to store the floats with it
READ_NUMBERS_LOOP:
	beq $t1, $t9, READ_NUMBERS_END # if N == i then jump READ_NUMBERS_END
	# Read float number
	addi $v0, $zero, 6
	syscall 
	swc1 $f0, 0($t8) # Store in array
	addi $t8, $t8, 4 # Move the pointer
	addi $t9, $t9, 1 # Increase loop counter
	j READ_NUMBERS_LOOP # Loop
READ_NUMBERS_END:
	add $v0, $zero, $t0 # Return pointer
	add $v1, $zero, $t1 # Return N
	jr $ra # Return
	
CALCULATE_AVERAGE:
	# This subroutine calculates the average of given array
	# a0 must be the array pointer and a1 must be the size
	# The output (average) will be in v0 which is a floating point number
	# We use f0 for sum; So we start with zero
	mtc1 $zero, $f0 # All zero bits = Zero in float
	add $t9, $zero, $zero # Initialize loop counter in t9
	add $t8, $zero, $a0 # Also initialize a pointer for reading variables
CALCULATE_AVERAGE_LOOP:
	beq $a1, $t9, CALCULATE_AVERAGE_DONE # if N == i then jump CALCULATE_AVERAGE_DONE
	lwc1 $f1, 0($t8) # Load the number from array
	add.s $f0, $f0, $f1 # Add to sum
	addi $t9, $t9, 1 # Increase loop counter
	addi $t8, $t8, 4 # Increase pointer position
	j CALCULATE_AVERAGE_LOOP
CALCULATE_AVERAGE_DONE:
	# We have the sum in f0
	# For average we convert the n to float and store it in f1
	mtc1 $a1, $f1
	cvt.s.w $f1, $f1
	# Now we divide
	div.s $f0, $f0, $f1
	# Move to v0
	mfc1 $v0, $f0
	jr $ra # Return
	
STANDARD_DEVIATION:
	# This subroutine calculates the standard deviation of given array
	# The a0 must be the array pointer
	# The a1 must be the array size
	# The a2 must be average of array elements in floating point representaion
	# The v0 will be the standard deviation
	mtc1 $zero, $f0 # All zero bits = Zero in float; We store the sum of power 2 in this
	mtc1 $a2, $f1 # We store the average in f1
	add $t9, $zero, $zero # Initialize loop counter in t9
	add $t8, $zero, $a0 # Also initialize a pointer for reading variables
STANDARD_DEVIATION_LOOP:
	beq $a1, $t9, STANDARD_DEVIATION_DONE # if N == i then jump CALCULATE_AVERAGE_DONE
	lwc1 $f2, 0($t8) # Load the number from array
	sub.s $f2, $f2, $f1 # (a - ?)
	mul.s $f2, $f2, $f2 # (a - ?) ^ 2
	add.s $f0, $f0, $f2 # Add the thing to other ones
	addi $t9, $t9, 1 # Increase loop counter
	addi $t8, $t8, 4 # Increase pointer position
	j STANDARD_DEVIATION_LOOP
STANDARD_DEVIATION_DONE:
	# Load the N to f1 (replacing the average)
	mtc1 $a1, $f1
	cvt.s.w $f1, $f1
	div.s $f0, $f0, $f1 # This is variance
	sqrt.s $f0, $f0 # This is standard deviation
	mfc1 $v0, $f0
	jr $ra # Return
	
STANDARD:
	# This subroutine calculates the standard deviation of given array
	# The a0 must be the array pointer
	# The a1 must be the array size
	# The a2 must be average of array elements in floating point representaion
	# The a3 must be standard deviation of array elements in floating point representaion
	# The v0 will be the pointer to fixed array; You have the size don't you? :D
	add $t9, $zero, $zero # Initialize loop counter in t9
	add $t8, $zero, $a0 # Also initialize a pointer for reading variables
	# Load the average and standard deviation
	mtc1 $a2, $f1 # We have average in f1
	mtc1 $a3, $f2 # We have standard deviation in f2
	# Create another array for standard
	addi $v0, $zero, 9
	sll $a0, $a1, 2 # Allocate N * 4 bytes
	syscall
	# Now the first of array will be in v0; We don't touch it until the last of subroutine!
	add $t7, $zero, $v0 # Create a copy to move the array pointer
STANDARD_LOOP:
	beq $t9, $a1, STANDARD_DONE
	lwc1 $f0, 0($t8) # Load the number
	sub.s $f0, $f0, $f1 # A - average
	div.s $f0, $f0, $f2 # (A - average) / standard deviation
	swc1 $f0, 0($t7) # Save in new array
	# Done calc
	addi $t9, $t9, 1 # Increase loop counter
	addi $t8, $t8, 4 # Increase pointer position
	addi $t7, $t7, 4 # Increase pointer position
	j STANDARD_LOOP # Loop
STANDARD_DONE:
	# We already have the pointer in v0
	jr $ra
	
PRINT_ARRAY:
	add $t9, $zero, $zero # Initialize loop counter in t9
	add $t8, $zero, $a0 # Also initialize a pointer for reading variables
PRINT_ARRAY_LOOP:
	beq $t9, $a1, PRINT_ARRAY_DONE
	lwc1 $f12, 0($t8) # Load the number
	addi $v0, $zero, 2
	syscall
	la $a0, space
	li $v0, 4
	syscall
	addi $t9, $t9, 1 # Increase loop counter
	addi $t8, $t8, 4 # Increase pointer position
	j PRINT_ARRAY_LOOP
PRINT_ARRAY_DONE:
	jr $ra

.data
newline:	.asciiz "\n"
space:		.asciiz " "
