(load "testing.scm")
; term-list representation for dense polynomials

; everything is the same as for sparse polynomials except 'adjoin-term'.
; Or so I thought !
; It's not that easy because we are not storing the order with the term coeff in the list. We're just storing the coeff,
; the order is implicit (given by the position in the list).
; Realized that looking at Eli's solution (see link below).
; Opting for a similar solution : terms are still order/coeff pairs, only they are not stored but reconstructed as they are queried.

;; representation of terms and term lists

; (1 2 0 3 -2 -5) represents x**5 + 2x**4 + 3x**2 - 2x - 5

; https://eli.thegreenplace.net/2007/09/21/sicp-section-253
; I think there's a bug in Eli's `adjoin-term` version: if we don't add terms that are 0, we offset out entire polynom by one order.
; To verify. I think this should show the issue:
; (adjoin-term 1 (the-empty-termlist))
; (adjoin-term 0 (the-empty-termlist))
; (adjoin-term 2 (the-empty-termlist))
; we expect 2x**2 + 1 and would get 2x + 1 with Eli's version (again, not tested yet).
; Also their 'first-term' implementation is not consistent with 'make-term' ? The latter uses a list and the former a pair.
; and the order of order/coeff isn't consistent either.

(define (adjoin-term term term-list)
  ; this is a little weird to my liking - term has an 'order' that *might not match* the one we're
  ; implicitly assigning (position in term list).
  ; adding a runtime verification to save debugging time, even if it increases runtime complexity a lot.
  (if (not (= (order term) (length term-list)))
    (error "inconsistent term to insert, order does not match. (order term) (length term-list):" (order term) (length term-list))
    (cons (coeff term) term-list)
    )
  )

(define (the-empty-termlist) '())
(define (first-term term-list)
  (make-term (- (length term-list) 1) (car term-list))
  )
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))
(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))


(check-equal
  "first term"
  (first-term (list 1 2 0 3 -2 -5))
  (list 5 1)
  )