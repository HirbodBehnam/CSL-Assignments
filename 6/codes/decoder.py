while True:
    a = int(input(), 16)
    temp_a = a
    result = ""
    for i in range(32):
        if i % 8 == 0:
            result += " "
        result += str(temp_a & 1)
        temp_a = temp_a>>1
    result = result[::-1]
    print(result)
    print("op: " + result[:6] + ", rs: " + str((a >> (32-6-5))%(2**5)) + ", rt: " + str((a >> (32-6-5-5))%(2**5)) + ", rd: " + str((a >> (32-6-5-5-5))%(2**5)) + ", shamt: " + str((a >> (32-6-5-5-5-5))%(2**5)) + ", funct: " + result[-7:])
    print("op: " + result[:6] + ", rs: " + str((a >> (32-6-5))%(2**5)) + ", rt: " + str((a >> (32-6-5-5))%(2**5)) + ", immediate: " + str(a % (2**16)))
    print("op: " + result[:6] + ", addr: " + "{0:#0{1}x}".format(a % (2**(32-6)), 10))
    print("===========")