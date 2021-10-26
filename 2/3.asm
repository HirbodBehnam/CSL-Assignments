.text
	jal READ_INPUT
	la $a0, filename_in
	jal REMOVE_NEW_LINE
	la $a0, filename_out
	jal REMOVE_NEW_LINE
	jal LOAD_FILES
	add $a0, $zero, $v0
	add $a1, $zero, $v1
	jal PROCESS_FILES
EXIT:
	addi $v0, $zero, 10
	syscall

READ_INPUT:
	# Print help
	addi $v0, $zero, 4
	la $a0, filename_in_help
	syscall
	# Get input
	addi $v0, $zero, 8
	la $a0, filename_in
	addi $a1, $zero, 40
	syscall
	# Print help
	addi $v0, $zero, 4
	la $a0, filename_out_help
	syscall
	# Get input
	addi $v0, $zero, 8
	la $a0, filename_out
	addi $a1, $zero, 40
	syscall
	jr $ra
	
REMOVE_NEW_LINE:
	# This subroutine removes the new line from given buffer
	# a0 must be the pointer to the buffer
	addi $a0, $a0, -1 # We need this because we increase this at first of loop
REMOVE_NEW_LINE_LOOP:
	addi $a0, $a0, 1
	lb $t0, 0($a0)
	beq $t0, $zero, REMOVE_NEW_LINE_END # We have reached the null terminator
	bne $t0, '\n', REMOVE_NEW_LINE_LOOP # If this is not the '\n' just continue the loop
	# We have to replace the \n with null terminator
	sb $zero, 0($a0)
	# Fall to REMOVE_NEW_LINE_END
REMOVE_NEW_LINE_END:
	jr $ra

LOAD_FILES:
	# Load files opens the input and output files
	# Returns the input file descriptor in v0
	# Returns the output file descriptor in v1
	# I will exit the program if it couldn't open one of the files
	# Open the input file
	addi $v0, $zero, 13
	la $a0, filename_in
	addi $a1, $zero, 0 # Open for reading
	addi $a2, $zero, 0 # Mode?
	syscall
	slt $t0, $v0, $zero # Check error (negative v0)
	bne $t0, $zero, LOAD_FILES_ERROR_IN
	# So we have opened the file!
	add $t0, $zero, $v0 # Save to t0
	# Now open the output file
	addi $v0, $zero, 13
	la $a0, filename_out
	addi $a1, $zero, 1 # Open for writing
	addi $a2, $zero, 0 # Mode?
	syscall
	slt $t1, $v0, $zero # Check error (negative v0)
	bne $t1, $zero, LOAD_FILES_ERROR_OUT
	add $t1, $zero, $v0 # Save to t1
	# So we have opened the file! Now return from subroutine
	add $v0, $zero, $t0
	add $v1, $zero, $t1
	jr $ra
	
LOAD_FILES_ERROR_IN:
	la $a0, in_error # Print error message
	addi $v0, $zero, 4
	syscall
	j EXIT # Exit from app

LOAD_FILES_ERROR_OUT:
	la $a0, out_error # Print error message
	addi $v0, $zero, 4
	syscall
	j EXIT # Exit from app
	
PROCESS_FILES:
	# Process files removes the vowels from the input and writes it to output file
	# This subroutine also counts the vowels in the input file and prints them in stdout
	# a0 must the be file input file descriptor
	# a1 must the be file output file descriptor
	# I want to store the a0 and a1 in s0 and s1 so I have to store them in stack
	# I also want to create a vowel counter in s2; So that also goes to stack
	# There is also a temp vowel for reading chars in s3
	sw $s0, -4($sp)
	sw $s1, -8($sp)
	sw $s2, -12($sp)
	sw $s3, -16($sp)
	addi $sp, $sp, -16
	# Now I can use s0 to s2!
	add $s0, $zero, $a0
	add $s1, $zero, $a1
	addi $s2, $zero, 0 # This a counter for vowels
PROCESS_FILES_LOOP:
	# Read one char from input
	add $a0, $zero, $s0
	sw $ra, -4($sp) # Save return address in stack
	addi $sp, $sp, -4
	jal READ_CHAR_FROM_FILE
	addi $sp, $sp, 4
	lw $ra, -4($sp) # Load return address from stack
	beq $v0, $zero, PROCESS_FILES_DONE # Done reading the file
	# Check vowel
	add $s3, $zero, $v0
	add $a0, $zero, $v0
	sw $ra, -4($sp) # Save return address in stack
	addi $sp, $sp, -4
	jal IS_VOWEL
	addi $sp, $sp, 4
	lw $ra, -4($sp) # Load return address from stack
	bne $v0, $zero, PROCESS_FILES_FOUND_VOWEL
	j PROCESS_FILES_WRITE_NORMAL
PROCESS_FILES_FOUND_VOWEL:
	addi $s2, $s2, 1 # Increase counter
	j PROCESS_FILES_LOOP # Loop
PROCESS_FILES_WRITE_NORMAL:
	add $a0, $zero, $s1
	add $a1, $zero, $s3
	sw $ra, -4($sp) # Save return address in stack
	addi $sp, $sp, -4
	jal WRITE_CHAR_TO_FILE
	addi $sp, $sp, 4
	lw $ra, -4($sp) # Load return address from stack
	j PROCESS_FILES_LOOP # Loop
PROCESS_FILES_DONE:
	la $a0, removed_letters_msg # Print removed letters message
	addi $v0, $zero, 4
	syscall
	add $a0, $zero, $s2
	addi $v0, $zero, 1
	syscall
	# Close files
	addi $v0, $zero, 16
	add $a0, $zero, $s0
	syscall
	addi $v0, $zero, 16
	add $a0, $zero, $s1
	syscall
	# Pop the stack
	addi $sp, $sp, 16
	lw $s0, -4($sp)
	lw $s1, -8($sp)
	lw $s2, -12($sp)
	lw $s3, -16($sp)
	jr $ra
	
READ_CHAR_FROM_FILE:
	# Read char from file will read a single character from a file
	# a0 must be the file descriptor
	# v0 will be the character read from file
	addi $v0, $zero, 14
	# a0 is the file descriptor
	addi $a1, $sp, -4 # Store the char in stack
	# -4 could possibly be -2 because we are reading one char (+ null terminator)
	# But maybe I get alignment error if I use -2 so I use -4
	addi $a2, $zero, 1 # Read one char at most
	syscall # Read one char
	addi $t0, $zero, 1
	slt $t0, $v0, $t0 # If v0 <= 0 then we return zero
	bne $t0, $zero, READ_CHAR_FROM_FILE_RETURN_ZERO # We didn't read anything (end of file possibly)
	# Otherwise load the read char from stack
	lb $v0, -4($sp)
	jr $ra
READ_CHAR_FROM_FILE_RETURN_ZERO:
	addi $v0, $zero, 0
	jr $ra

WRITE_CHAR_TO_FILE:
	# Write char to file will write a single character in file
	# a0 is the file descriptor
	# a1 is the char to write
	sw $a1, -4($sp)
	addi $v0, $zero, 15
	# we don't need to change a0
	addi $a1, $sp, -4
	addi $a2, $zero, 1
	syscall
	jr $ra
	
IS_VOWEL:
	# Is vowel checks if the given input is vowel or not
	# a0 must be character to check
	# v0 will be either one or zero (true or false)
	beq $a0, 'a', IS_VOWEL_RETURN_TRUE
	beq $a0, 'e', IS_VOWEL_RETURN_TRUE
	beq $a0, 'i', IS_VOWEL_RETURN_TRUE
	beq $a0, 'o', IS_VOWEL_RETURN_TRUE
	beq $a0, 'u', IS_VOWEL_RETURN_TRUE
	addi $v0, $zero, 0
	jr $ra
IS_VOWEL_RETURN_TRUE:
	addi $v0, $zero, 1
	jr $ra
	
.data
filename_in_help:	.asciiz "Enter the input filename: "
filename_in:		.space 40
filename_out_help:	.asciiz "Enter the output filename: "
filename_out:		.space 40
in_error:		.asciiz "Cannot read input file"
out_error:		.asciiz "Cannot create output file"
removed_letters_msg:	.asciiz "Number of removed letters: "
