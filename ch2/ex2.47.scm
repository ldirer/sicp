(load "ch2/ex2.46.scm")
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))


(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (cadr frame))
(define (edge2-frame frame) (caddr frame))


(define u (make-vect 1 0))
(define v (make-vect 0 1))

(define f (make-frame (make-vect 0 0) u v))

(origin-frame f)
(edge1-frame f)
(edge2-frame f)

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define f (make-frame (make-vect 0 0) u v))

(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (cadr frame))
(define (edge2-frame frame) (cddr frame))

(origin-frame f)
(edge1-frame f)
(edge2-frame f)
