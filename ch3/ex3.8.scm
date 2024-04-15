;Exercise:
;Deﬁne a simple procedure f such that evaluating
;(+ (f 0) (f 1))
;will return 0 if the arguments to + are evaluated from left to
;right but will return 1 if the arguments are evaluated from
;right to left.

(define (make-f)
  (define internal 0)

  (define (f n)
    (cond ((= n 1) (set! internal 1) 0)
      (else internal)
      )
    )
  f
  )

(define f (make-f))
(+ (f 1) (f 0))
(define f (make-f))
(+ (f 0) (f 1))


; Solution from: https://eli.thegreenplace.net/2007/09/27/sicp-sections-312-313
; I thought it was confusing at first because I misread the 'define f' as defining a function. It's defining a variable f.
; all good... I found the use of 'let' in that context a bit weird but it's used in the book too.
(define f
  (let ((state 1))
    (lambda (n)
      (set! state (* state n))
      state)))
;(+ (f 1) (f 0))
;(+ (f 0) (f 1))