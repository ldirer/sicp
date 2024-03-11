(load "ch2/2.5/generic.scm")

;(add 1 3)
;Bad tagged datum: TYPE-TAG 1

(define (attach-tag type-tag contents)
  (cond
    ((number? contents) contents)
    (else (cons type-tag contents))
    )
  )

(define (type-tag datum)
  (cond
    ((number? datum) 'scheme-number)
    ((pair? datum) (car datum))
    (else (error "Bad tagged datum: TYPE-TAG" datum))
    )
  )

(define (contents datum)
  (cond
    ((number? datum) datum)
    ((pair? datum) (cdr datum))
    (else (error "Bad tagged datum: CONTENTS" datum))
    )
  )


(add 1 3)
;Value: 4

; note we didn't need to change anything in our `scheme-number` package but some of the code inside it is now a bit stale.
; In particular this doesn't make a lot of sense - x is a number, the 'scheme-number argument will be ignored.
;(define (tag x) (attach-tag 'scheme-number x))
; All the tagging inside that package could be removed, it's only relevant that the right tags are used in `put` calls.