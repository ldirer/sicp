; delay and force are available in Scheme, we'll use these implementations.
; the book gives explanations about how they could be implemented.

(define-syntax cons-stream
  (syntax-rules ()
    ((_ x y) (cons x (delay y)))))


(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))


(define (stream-enumerate-interval low high)
  (if (> low high)
    the-empty-stream
    (cons-stream
      low
      (stream-enumerate-interval (+ low 1) high)))
  )


(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
    ((pred (stream-car stream))
      (cons-stream (stream-car stream)
        (stream-filter
          pred
          (stream-cdr stream))))
    (else (stream-filter pred (stream-cdr stream)))))

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))
    )
  )


(define (stream-map proc s)
  (if (stream-null? s)
    the-empty-stream
    (cons-stream (proc (stream-car s))
      (stream-map proc (stream-cdr s)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
    'done
    (begin (proc (stream-car s))
           (stream-for-each proc (stream-cdr s))))
  )

(define (display-stream s)
  (stream-for-each display-line s)
  )
(define (display-line x) (newline) (display x))


(define (scale-stream stream factor)
(stream-map (lambda (x) (* x factor))
stream))