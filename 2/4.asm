.text
MAIN:
	# Print help message
	addi $v0, $zero, 4
	la $a0, help
	syscall
	# Read the input
	addi $v0, $zero, 12
	syscall
	beq $v0, 'i', MAIN_INSERT
	beq $v0, 'd', MAIN_DELETE
	beq $v0, 'p', MAIN_PRINT
	beq $v0, 'x', EXIT
	# Invalid command!
	addi $v0, $zero, 4
	la $a0, invalid_command
	syscall
	j MAIN # Loop again
MAIN_INSERT:
	jal INSERT_READ
	j MAIN # Loop again
	
MAIN_DELETE:
	jal DELETE
	j MAIN # Loop again
	
MAIN_PRINT:
	jal PRINT
	j MAIN # Loop again

EXIT:
	addi $v0, $zero, 10
	syscall

INSERT_READ:
	# This subroutine, at first reads a number from input and if possible, inserts it to array
	# At first check the size
	la $t0, queue_size
	lw $t0, 0($t0)
	beq $t0, 10, INSERT_FULL
	# Print a help message
	addi $v0, $zero, 4
	la $a0, insert_help
	syscall
	# Get the numeber
	addi $v0, $zero, 5
	syscall
	# Call the insert subroutine
	add $a0, $zero, $v0
	addi $sp, $sp, -4
	sw $ra, 0($sp) # save ra in stack
	jal INSERT
	lw $ra, 0($sp) # load ra from stack
	addi $sp, $sp, 4
	# Return from subroutine
	jr $ra

INSERT_FULL:
	addi $v0, $zero, 4
	la $a0, queue_full
	syscall
	jr $ra
	
INSERT:
	# Insert inserts a0 into the queue
	# This subroutine must not be called if the stack is full
	# At first increase the size
	la $t0, queue_size
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	# Now load the head
	la $t0, queue_head
	lw $t1, 0($t0) # Now t1 has the head offset
	la $t2, queue # We will store the address which we need to store the number in t2
	add $t2, $t2, $t1 # Now the address is in t2
	sw $a0, 0($t2) # Save the number in queue
	# Now we have to move the head
	addi $t1, $t1, 4 # We add 4 to have the pointer offset
	# Mod for ring buffer
	addi $t2, $zero, 40
	div $t1, $t2
	mfhi $t1
	# Save it
	sw $t1, 0($t0)
	# Return
	jr $ra

DELETE:
	# Delete dequeues the queue the prints the removed element
	# If the queue is empty, it simply prints an error message
	# Check size
	la $t0, queue_size
	lw $t1, 0($t0) # Size is in t1
	beq $t1, $zero, DELETE_EMPTY
	addi $t1, $t1, -1
	sw $t1, 0($t0) # Reduce size and save
	# Print a help message
	addi $v0, $zero, 4
	la $a0, delete_message
	syscall
	# Now get the tail offset
	la $t0, queue # Queue first element pointer in t0
	la $t1, queue_tail # Queue tail offset address in t1
	lw $t2, 0($t1) # Tail offset is in t2
	add $t0, $t0, $t2 # Store the number address in t0
	# Print the number
	addi $v0, $zero, 1
	lw $a0, 0($t0)
	syscall
	# Move the tail
	addi $t2, $t2, 4
	addi $t3, $zero, 40
	div $t2, $t3
	mfhi $t2
	# Save the tail
	sw $t2, 0($t1)
	# Print a new line for formatting
	addi $v0, $zero, 4
	la $a0, new_line
	syscall
	# Return
	jr $ra

DELETE_EMPTY:
	addi $v0, $zero, 4
	la $a0, queue_empty
	syscall
	jr $ra

PRINT:
	# Print prints the queue
	# At first print a message
	addi $v0, $zero, 4
	la $a0, print_message
	syscall
	# Initialize a loop counter
	addi $t9, $zero, 0
	la $t8, queue_size
	lw $t8, 0($t8) # Load the size in t0
	# Load the first element address
	la $t0, queue
	la $t1, queue_tail
	lw $t1, 0($t1) # The tail offset is in t1
PRINT_LOOP:
	beq $t9, $t8, PRINT_DONE # End loop
	# Print number
	add $t2, $t0, $t1 # Create the address of the number
	lw $a0, 0($t2) # Load number from queue
	addi $v0, $zero, 1
	syscall
	addi $v0, $zero, 4
	la $a0, space_char
	syscall
	# Increase the loop counter
	addi $t9, $t9, 1
	# Move the address of the element
	addi $t1, $t1, 4
	addi $t2, $zero, 40
	div $t1, $t2
	mfhi $t1
	j PRINT_LOOP # loop
	
PRINT_DONE:
	addi $v0, $zero, 4
	la $a0, new_line
	syscall
	jr $ra
	


.data
queue:			.space 40
queue_head:		.word 0
queue_tail:		.word 0
queue_size:		.word 0
help:			.asciiz "I: Insert a new number in the queue\nD: Delete a number from the queue\nP: Print all numbers of the queue\nX: Exit\nPlease enter your choice: "
insert_help:		.asciiz "\nEnter the number to insert it in queue: "
delete_message:		.asciiz "\nHere is removed element from queue: "
print_message:		.asciiz "\nHere is the list of queue elements: "
invalid_command:	.asciiz "\ninvalid command\n"
queue_full:		.asciiz "\nqueue full\n"
queue_empty:		.asciiz "\nqueue empty\n"
new_line:		.asciiz "\n"
space_char:		.asciiz " "
