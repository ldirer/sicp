(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op
      (car sequence)
      (accumulate op initial (cdr sequence))
      )
    )
  )


(define (accumulate-n op init seqs)
  (if (null? (car seqs))
    (list)
    (cons (accumulate op init (map car seqs))
      (accumulate-n op init (map cdr seqs)))
    )
  )


; m is the 3x4 matrix
; (1 2 3 4)
; (4 5 6 6)
; (6 7 8 9)
(define m (list (list 1 2 3 4) (list 4 5 6 6) (list 6 7 8 9))) ;

; m2
;(1 2 0)
;(0 0 0)
;(0 0 0)
;(0 0 1)
(define m2 (list (list 1 2 0) (list 0 0 0) (list 0 0 0) (list 0 0 1)))

(define (print-matrix m) (
                           for-each (lambda (row)
                                      (newline)
                                      (display row)
                                      )
                           m
                           ))

(print-matrix m)
(print-matrix m2)


(define (dot-product v w) (accumulate + 0 (map * v w)))

(define v1 (list 1 0 0))
(dot-product v1 v1)
; expected: 1

(define (matrix-*-vector m v) (map (lambda (x) (dot-product v x)) m))


(matrix-*-vector m (list 1 0 0))
; expected: (1 4 6)


(define (transpose mat)
  (accumulate-n cons (list) mat)
  )

(transpose m)
; expected ((1 4 6) (2 5 7) (3 6 8) (4 6 9))


(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (col) (matrix-*-vector m col)) cols)
    )
  )

(matrix-*-matrix m m2)
; expected ((1 4 6) (2 8 12) (4 6 9))