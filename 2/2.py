import numpy
input_array = [1, 10]
standard_deviation = numpy.std(input_array)
avg = numpy.mean(input_array)
print(avg)
print(standard_deviation)
for i in input_array:
	print(str((i - avg) / standard_deviation) + " ", end='')