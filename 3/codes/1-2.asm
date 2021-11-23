# First fraction
mov R1, b
add R1, c  # R1 = b + c
mov R2, a
div R2, R1 # R2 = a / (b + c)
mov X, R2
# Second fraction
mov R1, d
add R1, a  # R1 = a + d
mov R2, d
div R2, R1 # R2 = d / (a + d)
add R2, X  # R2 += X
mov X, R2
# Third fraction
mov R1, a
add R1, d  # R1 = a + d
div R1, e  # R1 = (a + d) / e
mov R2, X
sub R2, R1 # R2 = R2 - R1 = X - (a + d) / e
mov X, R2