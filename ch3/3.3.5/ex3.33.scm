;Exercise 3.33: Using primitive multiplier, adder, and con-
;stant constraints, deﬁne a procedure averager that takes
;three connectors a, b, and c as inputs and establishes the
;constraint that the value of c is the average of the values of
;a and b.

(load "ch3/3.3.5/constraint.scm")
(load "ch3/3.3.5/connector.scm")

(define (averager a b c)
  (define sum (make-connector))
  (define half (make-connector))
  (constant 0.5 half)
  (adder a b sum)
  (multiplier half sum c)
  )


(define a (make-connector))
(define b (make-connector))
(define c (make-connector))
(define avg (averager a b c))

(set-value! a 4 'user)
(set-value! b 6 'user)
(get-value c)
; expected: 5
(probe "a" a)


(forget-value! a 'user)
(forget-value! b 'user)
(get-value a)
(get-value b)
(get-value c)

; we see that the values are still the same (not unset!). But they shouldn't be 'locked' anymore.
; I think it's mostly a quirk because if we only set a, c is not re-computed. Nor should it be!
; Why would it be recomputed over b?
(set-value! a 10 'user)
(set-value! c 2 'user)
(get-value a)
(get-value c)
(get-value b)
; expected: -6 \o/
