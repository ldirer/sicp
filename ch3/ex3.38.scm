; START OF CONCURRENCY EXERCISES

;Peter 1
(set! balance (+ balance 10))
;Paul 2
(set! balance (- balance 20))
;Mary 3
(set! balance (- balance (/ balance 2)))

; initial balance=100
; a. assuming the banking system forces the three processes to run sequentially in some order:
; possible values are:
; 123, 213: 100 + 10 - 20 - (100+10-20)/2 = 45
; 312, 321: 50 + 10 - 20 = 40
; 132: 110 - 110/2 - 20 = 35
; 231: 80 - 80/2 + 10 = 50
; enumerated all possible permutations (3!=6).


; b. if the system allows the processes to be interleaved, some other values that can be produced:
; 1. (+ balance 10) = 110
; 2. (- balance 20) = 80
; 1. set! balance 110 = balance <- 110
; 2. set! balance 80 = balance <- 80
; 3. entire process, result 40.

;similar scenario, swapping the set instructions of 1 and 2:
; 2. (- balance 20) = 80
; 1. (+ balance 10) = 110
; 1. set! balance 80
; 2. set! balance 110
; 3. entire process, result 55.

; I believe the two scenarios above are the only ones involving only 1 and 2.

; An example involving process 3:
; 3. / balance 2 = 50
; 1. + balance 10
; 1. set! balance 110
; 3. (- balance 50) = 110 - 50 = 60
; 2. entire expression: result 40
