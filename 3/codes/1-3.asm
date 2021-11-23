# First fraction
load b
add c
store temp # temp = b + c
load a
div temp # AC = a / (b + c)
store X
# Second fraction
load a
add d
store temp # temp = a + d
load d
div temp # AC = d / (a + d)
add X
store X
# Third fraction
load a
add d
div e # AC = (a + d) / e
store temp
load X
sub temp # AC = X => AC = X - (a + d) / e
store X