(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")
;3.50: n-ary stream-map
(load "ch3/ex3.50.scm")

(define (sign-change-detector curr prev)
  (cond
    ((and (< curr 0) (> prev 0)) -1)
    ((and (> curr 0) (< prev 0)) +1)
    (else 0)
    )
  )

; Louis Reasoner's attempt
(define (make-zero-crossings input-stream last-value)
  ; added termination handling (not in the book) to test procedure on finite sequences
  (if (stream-null? input-stream)
    the-empty-stream
    (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
      (cons-stream (sign-change-detector avpt last-value)
        (make-zero-crossings (stream-cdr input-stream) avpt))))
  )


(define sense-data (stream-from-list (list 1 2 1 .5 1 0 .5 -0 .1 -2 -3 -2 -0 .5 0 .2 3 4)))
(define zero-crossings (make-zero-crossings sense-data 0))

(display-stream (until zero-crossings 20))

; the issue with Louis Reasoner's version is that the average is computed between the current element and the
; 'last value', but that last value is *already* an average.
; We can fix it (without changing the structure of the program):

(define (make-zero-crossings input-stream last-smooth last-value)
  (if (stream-null? input-stream)
    the-empty-stream
    (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
      (cons-stream (sign-change-detector avpt last-smooth)
        (make-zero-crossings (stream-cdr input-stream) avpt (stream-car input-stream)))))
  )
(define zero-crossings (make-zero-crossings sense-data 0 0))

(define (pad-number num width)
  (let ((num-str (number->string num)))
    (if (< (string-length num-str) width)
        (string-append (make-string (- width (string-length num-str)) #\space) num-str)
        num-str)))


(display-stream-inline (until (stream-map (lambda (x) (pad-number x 4)) sense-data) 20))
(display-stream-inline (until (stream-map (lambda (x) (pad-number x 4)) zero-crossings) 20))
