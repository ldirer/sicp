; f(n) = n if n < 3 and f(n) = f(n -1) + 2 * f(n - 2) + 3 * f(n - 3) if n >= 3


(define (characteristic a b c) 
  (+ a (* 2 b) (* 3 c))
  )

; recursive process
(define (f n) 
  (cond ((< n 3) n)
        (else (characteristic (f (- n 1)) (f (- n 2)) (f (- n 3))))
  ))

; iterative process
(define (f_ n)
  (define (fi v1 v2 v3 n)
    (cond ((< n 2) n)
          ((= n 2) v1)  
          (else (fi (characteristic v1 v2 v3) v1 v2 (- n 1)))
     ))
  (fi 2 1 0 n)
  )

(f 27) ; takes a few seconds
;Value: 4583236459

(f_ 27) ; instant
;Value: 4583236459
  
(f_ 270)
;Value: 83526091950843930892362957658328667743573311871634916861727143354065541512763588608708796318225653419

; QUESTION this works but I didn't check the solution maybe there's something simpler.
; -> Looked at a solution here: https://sicp-solutions.net/post/sicp-solution-exercise-1-11/
; the loop is done in the other direction (doing (+ n 1) instead of (- n 1)) but otherwise similar.

