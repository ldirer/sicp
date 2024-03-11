(define (cont-frac n d k)
  (define (cont-frac-helper n d k i)
    (if (= k i)
         (/ (n k) (d k))
         (/ (n i) (+ (d i) (cont-frac-helper n d k (+ i 1))))
    ))

  (cont-frac-helper n d k 1)

  )


(cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 10)
(cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 20)
(cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 100)

;(cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 1000000)
;;Aborting!: maximum recursion depth exceeded

;In [4]: (1 + math.sqrt(5)) /2
;Out[4]: 1.618033988749895
;In [5]: 1/_
;Out[5]: 0.6180339887498948


; iterative version
(define (cont-frac-i n d k)
  (define (cont-frac-iter n d k result i)
    (if (= i 0)
      result
      (cont-frac-iter n d k (/ (n i) (+ (d i) result)) (- i 1))
      ))
  (cont-frac-iter n d k 1 k)
  )


(cont-frac-i (lambda (i) 1.0) (lambda (i) 1.0) 10)
(cont-frac-i (lambda (i) 1.0) (lambda (i) 1.0) 20)
(cont-frac-i (lambda (i) 1.0) (lambda (i) 1.0) 100)
(cont-frac-i (lambda (i) 1.0) (lambda (i) 1.0) 1000000)
