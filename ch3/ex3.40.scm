(define x 10)
(parallel-execute
  (lambda () (set! x (* x x)))
  (lambda () (set! x (* x x x)))
  )

; events P1: 2 accesses, computation, set
; events P2: 3 accesses, computation, set
; possible values:
; [serialized]
; P1, P2: 100**3 = 10**6
; P2, P1: 1000**2 = 10**6
; [not serialized]
; P2 3 accesses, P1 2 accesses, set P1, set P2: result 1000
; P2 3 accesses, P1 2 accesses, set P2, set P1: result 100
; P2 3 accesses, P1 access 1, set P2, P1 access 2, set P1: result 10 * 1000 = 10**4
; P2 access 1, P1 2 accesses, set P1, P2 access 2 & 3, set P2: 100 * 100 * 10 = 10**5
; P2 access 1 & 2, P1 2 accesses, set P1, P2 access 3, set P2: 100 * 10 * 10 = 10**4

;I think that's it.
; the sequence necessarily ends with a set. Can be P1 or P2.
; then it's about how the remaining 'set' is interleaved with accesses from the other process.
; 3 accesses in P2 -> 4 possible positions for set from P1.
; 2 accesses in P1 -> 3 possible positions for set from P2.
; total 7 cases.


