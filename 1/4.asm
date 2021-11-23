.text
	addi $s0, $zero, 1026
	# We shift the s0 until it is zero
	addi $s1, $zero, -1 # Initial value
LOOP:
	beq $s0, $zero, END
	srl $s0, $s0, 1
	addi $s1, $s1, 1
	j LOOP
END:
	
