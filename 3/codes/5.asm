# Initialize the answer as 1
pushi 1
pushi 0
pop R2
# Loop to calculate the factorial
FACTORIAL_LOOP:
bz R1, END # Check end of loop
# We have to calculate R2 * R1
# So we copy R1 to R15 and R14 to loop over it and sum it
# We also copy R2 to R13
# To copy the values we use stack
push R0
pop R13 # R13 = 0
push R2
pop R14 # R14 = R2
push R1
pop R15 # R15 = R1; Loop counter
MULT_LOOP:
bz R15, MULT_LOOP_DONE
# We have to do R13 = R14 + R14 ... + R14, R15 times
push R13
push R14
add
pop R13 # R13 = R13 + R14
# Now decrease the loop counter
# These two commands pushes -1 in stack
pushi -1
pushi -1
push R15
add # Now we have R15 - 1
pop R15 # R15--
j MULT_LOOP
MULT_LOOP_DONE:
# Mult loop done; We have answer in R13
push R13
pop R2
# Now decrease factorial the loop counter
# These two commands pushes -1 in stack
pushi -1
pushi -1
push R1
add # Now we have R1 - 1
pop R1 # R1--
j FACTORIAL_LOOP
END: