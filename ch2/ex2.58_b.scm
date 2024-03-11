(load "ch2/deriv.scm")
; overall this looks like it's sort-of correct ?
; Part of it is definitely lame though :)
; interestingly it looks like by keeping only the modifications in selectors the derivation function can still compute results.
; It outputs them in a non-simplified form (with a lot of parentheses).
; the changes in constructors serve this simplication purpose (they are the lame part).

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
    ((=number? a2 0) a1)
    ((and (number? a1) (number? a2))
      (+ a1 a2))
    ; if the parts are sums we can flatten them (removes extra parens)
    ((and (sumOrListOfSomething? a1) (sumOrListOfSomething? a2)) (append a1 (list '+) a2))
    ((sumOrListOfSomething? a1) (append a1 (list '+ a2)))
    ((sumOrListOfSomething? a2) (append (list a1 '+) a2))
    (else (list a1 '+ a2)))
  )

; lame :)
(define (sumOrListOfSomething? a)
  (and (pair? a) (not (product? a)))
  )

(define (productOrListOfSomething? a)
  (and (pair? a) (not (sum? a)))
  )

(define (memq? s expr)
  ;https://edoras.sdsu.edu/doc/mit-scheme-9.2/mit-scheme-ref/Booleans.html
  (boolean/and (memq s expr))
  ; alternative (before I found `boolean/and`):
  ;  (let ((sublist (memq s expr)))
  ;    (if (boolean=? sublist false)
  ;      false
  ;      true
  ;      )
  ;    )
  )

(memq? '+ '(x + 3))
; expected: true

; credits to ChatGPT
(define (complement-memq symbol lst)
  (cond ((null? lst) '())  ; if the list is empty, return an empty list
        ((eq? (car lst) symbol) '())  ; if the first element is the symbol, return an empty list
        (else (cons (car lst) (complement-memq symbol (cdr lst))))))  ; otherwise, keep the element and continue searching


(define (sum? x) (and (pair? x) (memq? '+ x)))
; '(2 * x + y) is a sum. First term is 2 * x.
(define (addend s) (flattenIfNotSumOrProduct (complement-memq '+ s)))
(define (augend s) (flattenIfNotSumOrProduct (cdr (memq '+ s))))

(define (flattenIfNotSumOrProduct expr)
  (if (and (pair? expr) (not (product? expr)) (not (sum? expr))) (car expr) expr)
  )




(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
    ((=number? m1 1) m2)
    ((=number? m2 1) m1)
    ((and (number? m1) (number? m2)) (* m1 m2))
    ; I think this does not remove all parentheses. It doesn't exploit precedence rules ?
    ; the approach is a bit lame anyway so not pushing it.
    ((and (productOrListOfSomething? m1) (productOrListOfSomething? m2)) (append m1 (list '*) m2))
    ((productOrListOfSomething? m1) (append m1 (list '* m2)))
    ((productOrListOfSomething? m2) (append (list m1 '*) m2))
    (else (list m1 '* m2))))


(define (product? x) (and (pair? x) (not (sum? x)) (memq? '* x)))
(define (multiplier p) (flattenIfNotSumOrProduct (complement-memq '* p)))
(define (multiplicand p) (flattenIfNotSumOrProduct (cddr p)))


(define expr '(3 + 2 * (x + 1) + 1))

(product? expr)
; expected: false
(sum? expr)
; expected: true
(addend expr)
; expected: 3
(augend expr)
;expected : 2 * (x + 1) + 1


;(make-sum (make-product (make-sum 'x 3) 'x) 'y)
; expected: (x + 3) * x + y

(make-sum (make-sum 'x 3) 1)

;(deriv '((x + 3) + 1) 'x)
(deriv '(x + 3 + 1) 'x)

(deriv '(x + 3 * (x + y + 2)) 'x)

; (x + 3) * (2 * 3 * x + y + 2) => (6 * x + y + 2) + 6 * (x + 3)
(deriv '((x + 3) * (2 * 3 * x + y + 2)) 'x)


(addend '(2 * x + y))
; expected: 2 * x
(augend '(2 * x + y))
; expected: y

(deriv '(2 * x + y) 'x)
; expected: 2
(deriv '((2 * x) + y) 'x)
; expected: 2
