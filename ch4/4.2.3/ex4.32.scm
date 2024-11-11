(load "ch4/4.2.3/lazylist.scm")
; > Give some examples that illustrate the difference between the streams of chapter 3 and the "lazier" lazy lists described in this section.
; > How can you take advantage of this extra laziness.

; Well... maybe it allows storing computations in streams, even if we don't need all of them.
; For instance if eventually we only take every other item in the stream (even index), it's fine.
; With the chapter3 streams we would have paid the computation penalty for all items regardless of whether we used them or not.
; (all items before the 'last processed item', that is).

; I guess we could extend that idea to store side effects... Like a fizzbuzz printer.
; Below is a bit of a code rambling. The idea of having side effects in a stream is relevant - the extra laziness means we can
; go through the stream without forcing elements (and thus side effects), which wouldn't be possible with chapter 3 streams.
; The idea of the fizzbuzz example adds to that


(define (and a b)
  (if a b false)
  )
(define fizzes (cons (display "fizz") fizzes))
(define buzzes (cons (display "buzz") buzzes))
(define fizzbuzzes (cons (display "fizzbuzz") fizzbuzzes))
; our map takes a single stream. My understanding is that writing the n-ary version as a procedure in our custom interpreter is not straightforward
; because `.` is not supported in the syntax. Since this is not the focus I have this workaround.
(define (group s1 s2 s3 s4)
  (if (null? s1)
    '()
    (cons
      (cons
        (car s1)
        (cons
          (car s2)
          (cons (car s3)
            (cons (car s4) '())
            )
          )
        )
      (group (cdr s1) (cdr s2) (cdr s3) (cdr s4))
      )
    )
  )

(define fizzbuzz-lazy (map
                        (lambda (group) (conditional (car group) (cadr group) (caddr group) (cadddr group)))
                        (group (cons 0 integers) fizzes buzzes fizzbuzzes)))

(define (conditional n fizz buzz fizzbuzz)
  (cond
    ((and (= (modulo n 3) 0) (= (modulo n 5) 0)) fizzbuzz)
    (else
      (cond
        ((= (modulo n 3) 0) fizz)
        ((= (modulo n 5) 0) buzz)
        )
      )
    )
  )


; This causes a **single** "buzz" to be emitted.
; None of the side effects in the first 99 items were executed.
; not exactly what I expected :). My point was more that we wouldn't be executing *every* fizz from the fizzes stream and every buzz from the buzzes stream, etc.
; I think the variation on `eval-sequence` from exercise 4.30 would change behavior: accessing the 100th element would print all fizz/buzz values for 1..100
; (but only the relevant ones!).
(list-ref fizzbuzz-lazy 100)
