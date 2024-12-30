; variants of stream-append and interleave that take a delayed argument (like with integral stuff in chapter 3).
; "This postpones looping in some cases (see ex4.71)"
(define (stream-append-delayed s1 delayed-s2)
  (if (stream-null? s1)
    (force delayed-s2)
    (cons-stream
      (stream-car s1)
      (stream-append-delayed (stream-cdr s1) delayed-s2))))

(define (interleave-delayed s1 delayed-s2)
  (if (stream-null? s1)
    (force delayed-s2)
    (cons-stream
      (stream-car s1)
      (interleave-delayed
        (force delayed-s2)
        (delay (stream-cdr s1))
        ; experiment removing the interleaving part:
;                (stream-cdr s1)
;                delayed-s2
        )
      )
    )
  )

(define (interleave s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream
      (stream-car s1)
      (interleave s2 (stream-cdr s1))
      )
    )
  )


(define (stream-flatmap proc s)
  (flatten-stream (stream-map proc s)))

(define (flatten-stream stream)
  (if (stream-null? stream)
    the-empty-stream
    (interleave-delayed
      (stream-car stream)
      (delay (flatten-stream (stream-cdr stream)))
      )
    )
  )

(define (singleton-stream x) (cons-stream x the-empty-stream))

(define (display-stream s)
  (stream-for-each display-line s)
  )
(define (display-line x) (newline) (display x))
