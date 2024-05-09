(load "ch3/3.3.5/constraint.scm")
(load "ch3/3.3.5/connector.scm")


;Louis Reasoner proposed squarer:
; This is flawed because multiplier treats its inputs as independant.
; It needs two out of three variables to compute the third one.
; the squarer only has 1 degree of freedom, but the multipier doesn't know about this.

(define (squarer a b)
  (multiplier a a b)
  )

(define a (make-connector))
(define b (make-connector))
(squarer a b)

(forget-value! a 'user)
(set-value! b 16 'user)
(get-value b)
(get-value a)
; #f: the squarer is not able to propagate back that 'a' should be 4.

;(set-value! a 4 'user)
;(get-value a)
;(get-value b)
;; 16: the squarer works in that direction.
