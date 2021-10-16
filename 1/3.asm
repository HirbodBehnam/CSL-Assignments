.text
	addi $t1, $zero, 10 # t1 = 10
	addi $t2, $zero, 3 # t2 = 3
	# Do t2 * 10
	add $t3, $t3, $t2 # 1
	add $t3, $t3, $t2 # 2
	add $t3, $t3, $t2 # 3
	add $t3, $t3, $t2 # 4
	add $t3, $t3, $t2 # 5
	add $t3, $t3, $t2 # 6
	add $t3, $t3, $t2 # 7
	add $t3, $t3, $t2 # 8
	add $t3, $t3, $t2 # 9
	add $t3, $t3, $t2 # 10
	add $t3, $t3, $t1 # t3 = t3 + t1 