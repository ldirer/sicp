; original problem/context ?

; discussion around numbers: complex numbers
; 2 representations:
;1. real + i * imaginary
;2. polar representation: mag * exp(i * angle)

;
;(define (make-complex-real-imag x y) (cons x y))
;(define (real-part z) (car z))
;(define (imag-part z) (cdr z))
;(define (magnitude-real-imag z) )
;
;(define (make-complex-polar mag ang) (cons mag ang))
;(define (magnitude z) (car z))
;(define (angle z) (cdr z))
;(define (real-part-for-polar z) )
;(define (imag-part-for-polar z) )
;
;
;
;(define (mul-real-imag z1 z2) )
;(define (mul-polar z1 z2) )
;
;(define (mul z1 z2) ((magnitude z1))
;
;
;





(define (add-complex z1 z2)
  (make-from-real-imag (+ (real-part z1) (real-part z2))
    (+ (imag-part z1) (imag-part z2))))
(define (sub-complex z1 z2)
  (make-from-real-imag (- (real-part z1) (real-part z2))
    (- (imag-part z1) (imag-part z2))))
(define (mul-complex z1 z2)
  (make-from-mag-ang (* (magnitude z1) (magnitude z2))
    (+ (angle z1) (angle z2))))
(define (div-complex z1 z2)
  (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
    (- (angle z1) (angle z2))))



; real + i* imag
(define (real-part z) (car z))
(define (imag-part z) (cdr z))
(define (magnitude z)
  (sqrt (+ (square (real-part z))
          (square (imag-part z)))))
(define (angle z)
  (atan (imag-part z) (real-part z)))
(define (make-from-real-imag x y) (cons x y))
(define (make-from-mag-ang r a)
  (cons (* r (cos a)) (* r (sin a))))

; polar
; cons mag ang
(define (real-part z) (* (magnitude z) (cos (angle z))))
(define (imag-part z) (* (magnitude z) (sin (angle z))))
(define (magnitude z) (car z))
(define (angle z) (cdr z))
(define (make-from-real-imag x y)
  (cons (sqrt (+ (square x) (square y)))
    (atan y x)))
(define (make-from-mag-ang r a) (cons r a))



;('polar mag ang)

; cons type-tag original-structure


(define (type-tag datum)
  (if (pair? datum)
    (car datum)
    (error "Bad tagged datum: TYPE-TAG" datum)))
(define (contents datum)
  (if (pair? datum)
    (cdr datum)
    (error "Bad tagged datum: CONTENTS" datum)))

(define (rectangular? z)
  (eq? (type-tag z) 'rectangular))
(define (polar? z) (eq? (type-tag z) 'polar))

(define (real-part z)
  (if (rectangular? z) (car (contents z)))
  (* (magnitude z) (cos (angle z)))
  )



(define (real-part-polar z)
  (* (magnitude-polar z) (cos (angle-polar z))))
(define (imag-part-polar z)
  (* (magnitude-polar z) (sin (angle-polar z))))
(define (magnitude-polar z) (car z))
(define (angle-polar z) (cdr z))
(define (make-from-real-imag-polar x y)
  (attach-tag 'polar
    (cons (sqrt (+ (square x) (square y)))
      (atan y x))))
(define (make-from-mag-ang-polar r a)
  (attach-tag 'polar (cons r a)))



(define (real-part z)
  (cond ((rectangular? z)
          (real-part-rectangular (contents z)))
    ((polar? z)
      (real-part-polar (contents z)))
    (else (error "Unknown type: REAL-PART" z))))

(define (imag-part z)
  (cond ((rectangular? z)
          (imag-part-rectangular (contents z)))
    ((polar? z)
      (imag-part-polar (contents z)))
    (else (error "Unknown type: IMAG-PART" z))))
(define (magnitude z)
  (cond ((rectangular? z)
          (magnitude-rectangular (contents z)))
    ((polar? z)
      (magnitude-polar (contents z)))
    (else (error "Unknown type: MAGNITUDE" z))))
(define (angle z)
  (cond ((rectangular? z)
          (angle-rectangular (contents z)))
    ((polar? z)
      (angle-polar (contents z)))
    (else (error "Unknown type: ANGLE" z))))


(define (make-from-real-imag x y)
  (make-from-real-imag-rectangular x y))
(define (make-from-mag-ang r a)
  (make-from-mag-ang-polar r a))



; data-directed: store a map type -> method-name -> method
(get 'rectangular 'magnitude)
; magnitude-rectangular
(get 'polar 'magnitude)

;(put)


(define (angle z) ((get (type-tag z) 'angle) (contents z)))


;(define (make-from-real-imag x y)
;
;  (define internal-magnitude)
;
;  (define (dispatch msg)
;    ((cond ((eq? msg 'magnitude) internal-magnitude)))
;    )
;
;  dispatch
;  )

(define (make-from-real-imag x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
      ((eq? op 'imag-part) y)
      ((eq? op 'magnitude) (sqrt (+ (square x) (square y))))
      ((eq? op 'angle) (atan y x))
      (else (error "Unknown op: MAKE-FROM-REAL-IMAG" op))))
  dispatch
  )




; redux: (state) => state