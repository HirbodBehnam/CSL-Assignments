.text
	# Strategy:
	# x = ((s0 >> 17) & 1111b) << 24
	# s1 = s1 & ~(1111b << 24)
	# s1 = s1 | x
	srl $s0, $s0, 17 # s0 >> 17
	andi $s0, $s0, 15 # s0 & 1111b
	sll $s0, $s0, 24 # s0 << 24
	# Now delete the bits from b
	addi $t0, $zero, 15 # store 1111b in t0
	sll $t0, $t0, 24 # t0 << 24
	nor $t0, $t0, $0 # ~t0
	and $s1, $s1, $t0 # Delete bits
	# Set bits
	or $s1, $s1, $s0
