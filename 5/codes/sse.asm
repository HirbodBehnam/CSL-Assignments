movaps xmm0, [v1] ; Load v1 in xmm0
addps xmm0, [v2]  ; xmm += v2
movaps [v3], xmm0 ; Move xmm0 to v3