
; Chat says memq stands for "member using `eq?`". Hmmmkay
(define (memq item x)
  (cond ((null? x) false)
    ((eq? item (car x)) x)
    (else (memq item (cdr x)))
    )
  )


(list 'a 'b 'c)
; expected: (a b c)

(list (list 'george))
; expected: ((george))

(cdr '((x1 x2) (y1 y2)))
; expected: ((y1 y2))

(cadr '((x1 x2) (y1 y2)))
; expected: (y1 y2)

(pair? (car '(a short list)))
; expected: false (testing if the symbol `a` is a pair)

(memq 'red '((red shoes) (blue socks)))
; false

(memq 'red '(red shoes blue socks))
; (red shoes blue socks)
