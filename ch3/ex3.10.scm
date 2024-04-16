; The two versions differ in structure: the `let` version will create an extra frame in the environments that W1 and W2 point to.

; W1 is defined in the global env, the env pointer part points to E2.
; E1: initial-amount: 100, points to global env.
; E2: balance: 50, points to E1.
; W2 is defined in the global env, the env pointer part points to E2.
; E3: initial-amount: 100, points to global env.
; E4: balance: 100, points to E3.
