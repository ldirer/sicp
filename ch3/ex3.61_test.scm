(load "ch3/ex3.61.scm")

(define exp-inverted-series (invert-unit-series exp-series))
(display-line "exp-inverted-series")
(display-stream (until exp-inverted-series 10))
(display-line "exp-series")
(display-stream (until exp-series 10))

(display-stream (until (mul-series exp-inverted-series exp-series) 10))

(define non-unit (scale-stream exp-series 2))
;(display-stream (until exp-series 10))
(eval-series non-unit 1 100)
(eval-series (invert-series non-unit) 1 100)

(eval-series (mul-series non-unit (invert-series non-unit)) 12 100)
;expected: 1
