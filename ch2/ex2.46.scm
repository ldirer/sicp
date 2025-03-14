(define (make-vect x y) (list x y))

(define (xcor-vect v) (car v))
(define (ycor-vect v) (cadr v))

(define (add-vect v1 v2) (make-vect (+ (xcor-vect v1) (xcor-vect v2)) (+ (ycor-vect v1) (ycor-vect v2))))
(define (sub-vect v1 v2) (make-vect (- (xcor-vect v1) (xcor-vect v2)) (- (ycor-vect v1) (ycor-vect v2))))
(define (scale-vect s v) (make-vect (* s (xcor-vect v)) (* s (ycor-vect v))))

(define u (make-vect 1 2))
(add-vect u u)
; expected: (2 4)
(sub-vect u u)
; expected: (0 0)

(scale-vect 3 u)
; expected: (3 6)
