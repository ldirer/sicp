(load "pairing/20241009_streams.scm")


; exercise 3.59

;e integral of the series a 0 + a 1x + a 2x 2 + a 3x 3 + . . .
;is the series XXXX
;where c is any constant. Deﬁne a procedure integrate-
;series that takes as input a stream a 0 , a 1 , a 2 , . . . rep-
;resenting a power series and returns the stream a 0 ,
;1
;a , 1 a , . . . of coeﬃcients of the non-constant terms
;2 1 3 2
;of the integral of the series. (Since the result has no
;constant term, it doesn’t represent a power series; when
;we use integrate-series, we will cons on the ap-
;propriate constant.)


(define (add-streams s1 s2) (stream-map + s1 s2))
(define incrementing-stream (cons-stream 1 (add-streams incrementing-stream ones)))

;(stream-map function stream1 stream2 stream3)
; returns a stream of (function element1-stream1 element1-stream2 element1-stream3) ...

; series: stream of coefficients: (a0 a1 a2 a3 a4...
(define (integrate-series series)
  (stream-map
    ; maybe do an operation with index and coefficient to return the expected 'new coefficient'
    (lambda (index coeff) (* coeff (/ 1 index)))
    incrementing-stream
    series
    )
  )

; test with a0
(take (integrate-series ones) 10)
; expected: 1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/9, 1/10

; f: x -> a0 + a1 * x + a2 * x**2 + a3 * x**3 + ...
; f': x -> 0 + a1 + a2 * 2 * x + a3 * 3 * x ** 2 + ...



; derivative rules:
; f' or df/dx
; constant -> 0
; x -> 1
; f: x -> x ** 2
; f': x -> 1/2 * x
; f: x  -> x ** n
; f': x -> 1/n * x ** (n-1)

; f: x -> exp(x)
; f': x -> exp(x)



; f: x -> cos(x)
; f': x -> -sin(x)
; f: x -> sin(x)
; f': x -> cos(x)
; sine is the integral of cosine

; very weird: recursive definition *of a variable* (!?)
(define ones (cons-stream 1 ones))

;Construct ones:
;- Start with 1
;- Continue with all the elements in ones

; even weirder
(define exp-series (cons-stream 1 (integrate-series exp-series)))
(take exp-series 10)
(define cosine-series (cons-stream 1 (scale-stream (integrate-series sine-series) -1)))
(define sine-series (cons-stream 0 (integrate-series cosine-series)))

(take cosine-series 10)
; 1, 0, -1/2, 0, 1/24, ..
(take sine-series 10)
; 0, 1, 0, -1/6, ..

(define (sum numbers)
  (reduce + 0 numbers)
  )

(define (evaluate series x n)
  ; compute a0 + a1 * x + a2 * x**2 + ... for a given value of x
  (sum (map
         (lambda (index coeff) (* coeff (expt x (- index 1))))
         (take incrementing-stream n)
         (take series n)
         )
    )
  )
(evaluate exp-series 0 100)
; expected: around 1

(evaluate cosine-series 0 100)
; expected: around 1
(evaluate sine-series 0 100)
; expected: around 0

(evaluate sine-series (/ 3.14 2) 100)
; expected: around 1
