(define count 0)
(define (id x)
  (set! count (+ count 1))
  x
  )

(define w (id (id 10)))

;;; L-eval input
count
; expecting: 1

;;; L-eval input
w
; expecting: 10

;;; L-eval input
count
; expecting 2


; Explanation:
; (define w (id (id 10))) runs (id (id 10)) first, as (id <SOME CALCULATION FOR LATER>).
; It enters the body, doing count += 1. Then it needs the value, so it looks at the thunk stored calculation: (id 10)
; At this stage it returns *the thunk*: w is a thunk.
; it is only forced when we output it.
; We can make things clearer with a different setup. Note that using `display` is not possible here out of the box.
; We could add it as a primitive procedure, but since these are all strict in their arguments, calling it would change behavior.

; This all makes sense, but it is definitely confusing.

(define count 0)
(define (id x)
  (set! count (+ count 1))
  x
  )
(define (id-outer x)
  (set! count (+ count 10))
  x
  )

count
;0
(define w (id-outer (id "ok")))
count
;10
; At this stage w is a thunk, outputting it in the REPL has the side effect of forcing it and changing count.
w
;ok
count
;11