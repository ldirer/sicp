; delay and force are available in Scheme, we'll use these implementations.
; the book gives explanations about how they could be implemented.

(define-syntax cons-stream
  (syntax-rules ()
    ((_ x y) (cons x (delay y)))))

;cons first-term (lambda: cdr-of-stream)

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



(define ones (cons-stream 1 ones))

(stream-car ones)

; broken
(define incrementing-sequence (cons-stream 1 ((stream-enumerate-interval low high))))


(define (take stream n)
  (if (= n 0) '()
              (cons (stream-car stream) (take (stream-cdr stream) (- n 1)))
    ))


(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
    ((stream-null? s2) s1)
    (else
      (let ((s1car (strGeam-car s1))
             (s2car (stream-car s2)))
        (cond ((< s1car s2car)
                (cons-stream
                  s1car
                  (merge (stream-cdr s1) s2)))
          ((> s1car s2car)
            (cons-stream
              s2car
              (merge s1 (stream-cdr s2))))
          (else
            (cons-stream
              s1car
              (merge (stream-cdr s1)
                (stream-cdr s2)))))))))

;(trace merge)
;TODO trace through this to see how much duplicate
;(define S (cons-stream 1 (merge (scale-stream S 2) (scale-stream S 3))))

;(take S 7)
(define (stream-map proc . argstreams)
  (if (null? (car argstreams))
    the-empty-stream
    ; Funny gotcha here!! I had 'stream-cons' instead of 'cons-stream' and it produced...
    ; maximum recursion depth errors!
    ; that's because the typo-ed procedure is not a special form, and its arguments are evaluated before the function call.
    ; so Scheme doesn't even know there's a typo, it's busy recursing in the arguments!
    ; realized that in ex3.53 where we use this stream-map.
    (cons-stream
      (apply proc (map stream-car argstreams))
      (apply stream-map
        (cons proc (map stream-cdr argstreams)))))
  )
