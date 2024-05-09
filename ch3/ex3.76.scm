(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")
;3.50: n-ary stream-map
(load "ch3/ex3.50.scm")

(define sense-data (stream-from-list (list 1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4)))
(define (sign-change-detector curr prev)
  (cond
    ((and (< curr 0) (> prev 0)) -1)
    ((and (> curr 0) (< prev 0)) +1)
    (else 0)
    )
  )

; a much better solution (https://mk12.github.io/sicp/exercise/3/5.html#ex3.76)
; there's an offset by one compared with my version due to how the average is done.
; the interesting part is that smooth uses stream-map instead of reinventing the wheel.
; (and we also can reuse zero-crossings from ex3.74)
(define (average a b) (/ (+ a b) 2))
(define (zero-crossings s)
  (stream-map sign-change-detector sense-data (cons-stream 0 sense-data)))
(define (smooth s) (stream-map average s (cons-stream 0 s)))
(define (smooth-zero-crossings sense-data) (zero-crossings (smooth sense-data)))

(display-stream-inline (smooth-zero-crossings sense-data))


;my original more modular version
(define (make-zero-crossings input-stream smooth)
  (define smoothed (smooth sense-data))
  (stream-map sign-change-detector smoothed (cons-stream 0 smoothed))
  )


(define (smooth-avg s)
  (define (iter prev s)
    (if (stream-null? s)
      s
      (cons-stream (/ (+ prev (stream-car s)) 2) (iter (stream-car s) (stream-cdr s)))
      )
    )
  ;adding the first element unchanged so that the smoothed stream is 'aligned' with the input stream
  (cons-stream (stream-car s) (iter (stream-car s) (stream-cdr s)))
  )


(display-stream-inline (until (smooth-avg integers) 20))

(define zero-crossings (make-zero-crossings sense-data smooth-avg))


(define (pad-number num width)
  (let ((num-str (number->string num)))
    (if (< (string-length num-str) width)
      (string-append (make-string (- width (string-length num-str)) #\space) num-str)
      num-str)))

(display-stream (until zero-crossings 20))

(display-stream-inline (until (stream-map (lambda (x) (pad-number x 4)) sense-data) 20))
(display-stream-inline (until (stream-map (lambda (x) (pad-number x 4)) zero-crossings) 20))
