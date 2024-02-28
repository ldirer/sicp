; [Ben wrote a] test whether the interpreter we're using is using applicative-order evaluation or normal-order evaluation.


(define (p) (p))
; already: wut. A procedure named p, no arguments, returning itself.

(define (test x y)
  (if (= x 0)
    0
    y))


; command to test things out:
(test 0 (p))

; prediction: 
; NORMAL ORDER EVALUATION: Ben will see 0. (p) is *never evaluated*.
; APPLICATIVE ORDER EVALUATION: Uh... Infinite recursion ?
; yes, infinite recursion is what I get running `(p)` alone.
; It manifests as: nothing is printed, the interpreter hands whil working very CPU-hard. INTERESTING BEHAVIOR ON ITS OWN.


