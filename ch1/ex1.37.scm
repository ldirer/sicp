

(define (cont-frac n d k)
(define (cont-frac-helper n d k i)
  if ((= k i) (/ n d)
      (/ (n i) (+ (d i) (cont-frac n d k (+ i 1)))))
  )

(cont-frac-helper n d k 1)

)


(cont-frac (lambda (i) 1.) (lambda (i) 1.) 10)
(cont-frac (lambda (i) 1.) (lambda (i) 1.) 20)
(cont-frac (lambda (i) 1.) (lambda (i) 1.) 100)

