;from book
(define (make-from-real-imag x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
      ((eq? op 'imag-part) y)
      ((eq? op 'magnitude) (sqrt (+ (square x) (square y))))
      ((eq? op 'angle) (atan y x))
      (else (error "Unknown op: MAKE-FROM-REAL-IMAG" op))))
  dispatch)

(define (apply-generic op arg) (arg op))
;/from book


(define (make-from-mag-ang mag ang)
  (define (dispatch op)
    (cond
      ((eq? op 'real-part) (* mag (cos ang)))
      ((eq? op 'imag-part) (* mag (sin ang)))
      ((eq? op 'magnitude) mag)
      ((eq? op 'angle) ang)
      (else (error "Unknown op: MAKE-FROM-MAG-ANG" op))
      )
    )
  dispatch
  )

(apply-generic 'real-part (make-from-mag-ang 2 0))
;expected 2

(apply-generic 'real-part (make-from-mag-ang (sqrt 2) (/ 3.14 4)))
;expected ~1
