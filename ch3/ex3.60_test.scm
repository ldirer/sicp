(load "ch3/ex3.60.scm")

(display-stream (until (add-streams cos-squared sin-squared) 10))
; expected: 1 0 0 0 0 0...
