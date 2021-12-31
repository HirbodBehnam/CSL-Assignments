.text
lui $at, 4097 # op: 001111, rs: 0, rt: 1, immediate: 4097
ori $s0, $at, 0 # op: 001101, rs: 1, rt: 16, immediate: 0
lwc1 $f1, 0($s0) # op: 110001, rs: 16, rt: 1, immediate: 0
lwc1 $f2, 4($s0) # op: 110001, rs: 16, rt: 2, immediate: 4
c.le.s $f1, $f2 # 010001, rs: 16, rt: 2, rd: 1, shamt: 0, funct: 111110
bc1f SUB # op: 010001, rs: 8, rt: 0, immediate: 2
add.s $f0, $f1, $f2 # op: 010001, rs: 16, rt: 2, rd: 1, shamt: 0, funct: 000000
j END # op: 000010, addr: 0x00100009
SUB:
sub.s $f0, $f1, $f2 # op: 010001, rs: 16, rt: 2, rd: 1, shamt: 0, funct: 000001
END:
swc1 $f0, 8($s0) # op: 111001, rs: 16, rt: 0, immediate: 8
.data
.word 0x41266666
.word 0x4179999a
.word 0