; Chat says memq stands for "member using `eq?`". Hmmmkay
(define (memq item x)
  (cond ((null? x) false)
    ((eq? item (car x)) x)
    (else (memq item (cdr x)))
    )
  )



; this solution isn't fantastic, we don't explicitly test that things are symbols (which I think would be preferrable).
(define (equal? a b)
  (or (and (null? a) (null? b))
    (and (pair? a) (pair? b) (eq? (car a) (car b)) (equal? (cdr a) (cdr b)))
    (eq? a b)
    )
  )


(equal? '(this is a list) '(this is a list))
; expected: true

(equal? '(this is a list) '(this (is a) list))
; expected: false
