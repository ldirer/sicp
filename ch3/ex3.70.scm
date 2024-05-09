(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")

(define (merge-weighted s t weight)
  (cond
    ((stream-null? s) t)
    ((stream-null? t) s)
    ((< (weight (stream-car s)) (weight (stream-car t)))
      (cons-stream (stream-car s) (merge-weighted (stream-cdr s) t weight))
      )
    (else (cons-stream (stream-car t) (merge-weighted s (stream-cdr t) weight)))
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

; adapted from the 'pairs' function
(define (weighted-pairs s t weight)
  (cons-stream
    ; s0, t0
    (list (stream-car s) (stream-car t))
    (merge-weighted
      ; (s0, t1), (s0, t2), ...
      (stream-map
        (lambda (x) (list (stream-car s) x))
        (stream-cdr t)
        )

      (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
      weight
      )
    )
  )

(define pairs-i+j (weighted-pairs integers integers (lambda (x) (+ (car x) (cadr x)))))

; commented to avoid polluting output of files that import this one
;(display-stream (until pairs-i+j 20))


; sum of all pairs of positive integers with i <= j where neither i nor j is divisible by 2, 3, or 5, and the pairs are ordered according to the sum 2i + 3j + 5ij
(define (weight-b pair) (+ (* 2 (car pair)) (* 3 (cadr pair)) (* 5 (car pair) (cadr pair))))
(define prefiltered-integers (stream-filter
                               (lambda (n) (not (or (= (remainder n 2) 0) (= (remainder n 3) 0) (= (remainder n 5) 0))))
                               integers))
(define these-pairs (weighted-pairs prefiltered-integers prefiltered-integers weight-b))

;(display-stream (until these-pairs 20))
;(1 1)
;(1 7)
;(1 11)
;(1 13)
;(1 17)
;(1 19)
;(1 23)
;(1 29)
;(1 31)
;(7 7)
;(1 37)
;(1 41)
;(1 43)
;(1 47)
;(1 49)
;(1 53)
;(7 11)
;(1 59)
;(1 61)
;(7 13)
