(load "ch2/deriv.scm")

; part a. (assuming infix operators but with balanced parentheses and only 2 arguments each time) requires very few changes.
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
    ((=number? a2 0) a1)
    ((and (number? a1) (number? a2))
      (+ a1 a2))
    (else (list a1 '+ a2)))
  )

(define (sum? x) (and (pair? x) (eq? (cadr x) '+)))
(define (addend s) (car s))
(define (augend s) (caddr s))


(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
    ((=number? m1 1) m2)
    ((=number? m2 1) m1)
    ((and (number? m1) (number? m2)) (* m1 m2))
    (else (list m1 '* m2))))


(define (product? x) (and (pair? x) (eq? (cadr x) '*)))
(define (multiplier p) (car p))
(define (multiplicand p) (caddr p))


(define prod '(2 * x))
(define sum '(1 + y))

(product? prod)
; expected: true
(product? sum)
; expected: false

(sum? sum)
; expected: true
(sum? prod)
; expected: false

(multiplier prod)
; expected: 2
(multiplicand prod)
; expected: x

(addend sum)
; expected: 1
(augend sum)
;expected : y

(deriv '(x + (3 * (x + (y + 2)))) 'x)