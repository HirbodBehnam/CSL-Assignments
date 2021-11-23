# First fraction
mov R1, b
add R1, R1, c # R1 = b + c
div R1, a, R1 # R1 = a / (b + c)
mov X, R1
# Second fraction
mov R1, d
add R2, R1, a  # R2 = a + d
div R1, R2, R1 # R1 = d / (a + d)
add R1, R1, X  # R1 += X
mov X, R1
# Third fraction
mov R1, a
add R1, R1, d # R1 = a + d
div R1, R1, e # R1 = (a + d) / e
sub R1, X, R1 # R1 = X - R1
mov X, R1