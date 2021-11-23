.text
	jal READ_INPUT
	jal LOAD_NUMBERS
	add $a0, $zero, $v0
	add $a1, $zero, $v1
	jal PROCESS_INPUT
	add $a0, $zero, $v0
	jal PRINT_BOOL
	# Terminate
	addi $v0, $zero, 10
	syscall
	
READ_INPUT:
	# This subroutine reads the first input from stdin
	la $a0, input # Load to data segment
	addi $a1, $zero, 4 # 3 chars max (+ null)
	addi $v0, $zero, 8
	syscall
	jr $ra

PROCESS_INPUT:
	# This subroutine will to the calculation to check if the given op is true or false
	# a0 must be the value of first number which user has entered
	# a1 must be the value of second number which user has entered
	# v0 will be either 0 or 1 based on the op
	la $t0, input # Load the address of input string
	lbu $t0, 1($t0) # Load the operator
	beq $t0, '<', PROCESS_INPUT_LESS
	beq $t0, '>', PROCESS_INPUT_MORE
	# Otherwise we continue to PROCESS_INPUT_EQUAL
PROCESS_INPUT_EQUAL:
	bne $a0, $a1, PROCESS_INPUT_RETURN_FALSE # if a0 != a1 then goto PROCESS_INPUT_RETURN_FALSE
	# Otherwise they are equal
PROCESS_INPUT_RETURN_TRUE:
	addi $v0, $zero, 1
	jr $ra
PROCESS_INPUT_RETURN_FALSE:
	addi $v0, $zero, 0
	jr $ra
PROCESS_INPUT_LESS:
	slt $v0, $a0, $a1 # v0 = a0 < a1
	jr $ra
PROCESS_INPUT_MORE:
	sgt $v0, $a0, $a1 # v0 = a0 > a1
	jr $ra
	
LOAD_NUMBERS:
	# Load numbers will load the saved numbers in data segment based on "input"
	# The first number will be in $v0 and the second one will be in $v1
	la $t1, a_num # Load a in t1
	lw $t1, 0($t1) # Load a in t1
	la $t2, b_num # Load b in t2
	lw $t2, 0($t2) # Load b in t2
	la $t0, input # Load the address of input string
	lbu $t0, 0($t0) # Load the first character in t0
	beq $t0, 'b', LOAD_NUMBERS_B_FIRST # If the first number is b jump to that number
	# If not continue execution
LOAD_NUMBERS_A_FIRST:
	add $v0, $zero, $t1 # v0 = a
	j LOAD_FIRST_NUMBER_DONE
	
LOAD_NUMBERS_B_FIRST:
	add $v0, $zero, $t2 # v0 = b
	j LOAD_FIRST_NUMBER_DONE
	
LOAD_FIRST_NUMBER_DONE:
	la $t0, input # Load the address of input string
	lbu $t0, 2($t0) # Load the first character in t0
	beq $t0, 'b', LOAD_NUMBERS_B_SECOND # If the first number is b jump to that number
	# If not continue execution
LOAD_NUMBERS_A_SECOND:
	add $v1, $zero, $t1 # v1 = a
	jr $ra
	
LOAD_NUMBERS_B_SECOND:
	add $v1, $zero, $t2 # v1 = b
	jr $ra
	
	
PRINT_BOOL:
	# Print bool simply prints either true of false based on input
	# If a0 is zero, it will print false otherwise true
	addi $v0, $zero, 4 # Make the syscall ready
	beq $a0, $zero, PRINT_BOOL_FALSE
PRINT_BOOL_TRUE:
	la $a0, true
	syscall
	jr $ra
	
PRINT_BOOL_FALSE:
	la $a0, false
	syscall
	jr $ra

.data
true:	.asciiz "true\n"
false:	.asciiz "false\n"
a_num:	.word 6
b_num:	.word 8
input:	.space 4 # 4 bytes for input (3+null)
