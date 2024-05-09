; like reduce (Array.reduce)
(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op
      (car sequence)
      (accumulate op initial (cdr sequence))
      )
    )
  )

;sum = accumulate + 0
(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) (+ this-coeff (* x higher-terms)))
    0
    coefficient-sequence)
  )

(define (eval-poly x coefficient-sequence)
  (define (iter current-power-x coefficient-sequence result)
    (if (null? coefficient-sequence)
      result
      (iter (* x current-power-x) (cdr coefficient-sequence) (+ result (* (car coefficient-sequence) current-power-x)))
      )
    )

  (iter 1 coefficient-sequence 0)
  )

;[1, 3, 0, 5, 0, 1].map(square).reduce((item, accumulator) => accumulator += item, 0)



(horner-eval 2 (list 1 3 0 5 0 1))
;expected: 32+47=79?

(eval-poly 2 (list 1 3 0 5 0 1))
