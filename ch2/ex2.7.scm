
(define (make-interval a b) (cons a b))
(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))

(define unit (make-interval 0 1))

(lower-bound unit)
(upper-bound unit)



; TODO@ldirer 2.8
(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y)) (- (upper-bound x) (lower-bound y)))
)
