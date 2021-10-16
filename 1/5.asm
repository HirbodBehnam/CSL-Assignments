.text
	addi $a1, $zero, 12345
	addi $a0, $zero, 54321
	jal min
	add $a0, $zero, $v0
	addi $v0, $zero, 1
	syscall
	# Terminate
	addi $v0, $zero, 10
	syscall
min:
	# The method I'm using:
	# https://www.geeksforgeeks.org/compute-the-minimum-or-maximum-max-of-two-integers-without-branching/
	# a + ((b - a) & ((b - a) >> (sizeof(int) * 8 - 1)))
	# a + ((b - a) & ((b - a) >> 31)
	# a0 = a, a1 = b
	sub $t0, $a1, $a0 # b - a
	sra $t1, $t0, 31 # (b - a) >> 31
	and $t0, $t0, $t1 # ((b - a) & ((b - a) >> 31)
	add $v0, $t0, $a0 # a + ((b - a) & ((b - a) >> 31)
	jr $ra # Return
