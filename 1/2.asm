.text
	# We cannot store this number by just typing
	# addi $s0, $zero, 2568426291
	# That would assemble to some other ops
	# We load second 16 bytes, shift them 16 bytes and then "or" with first 16 bytes
	# My student number is 99171333 which is 2568426291 in base 10
	# First second 16 bytes are 39191 which basically is -26345
	addi $s0, $zero, -26345 # Load 16 second bytes
	sll $s0, $s0, 16 # Fix the position of bytes
	ori $s0, $s0, 4915 # Load the first 16 bytes
	# Print 2 bytes by 2 bytes
	addi $v0, $zero, 1 # Print in base 10
	# Start from last 4 bits and come down
	srl $a0, $s0, 28
	andi $a0, $a0, 15
	syscall
	srl $a0, $s0, 24
	andi $a0, $a0, 15
	syscall
	srl $a0, $s0, 20
	andi $a0, $a0, 15
	syscall
	srl $a0, $s0, 16
	andi $a0, $a0, 15
	syscall
	srl $a0, $s0, 12
	andi $a0, $a0, 15
	syscall
	srl $a0, $s0, 8
	andi $a0, $a0, 15
	syscall
	srl $a0, $s0, 4
	andi $a0, $a0, 15
	syscall
	andi $a0, $s0, 15
	syscall
