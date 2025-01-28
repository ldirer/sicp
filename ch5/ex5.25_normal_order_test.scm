; use eceval-normal

; this is the sort of test that failed for a long time.
(+)
(+ 1)
(+ 1 2)

; nice because it tests the order of things
(- 2 1)


; p404 paper
(define (try a b)
  (if (= a 0) 1 b)
  )
(try 0 (/ 1 0))
; expected 1


; from exercise 4.27.
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

(define (decider arg)
  (display "IN DECIDER")
  arg
  )

(define (if-test)
  (if (decider #f)
    (begin (display "if-test: true, thunk was interpreted as true when it should have been forced!") 'nok)
    (begin (display "if-test: false, all good.") 'ok)
    )
  )

(define a (decider #f))

(if-test)
