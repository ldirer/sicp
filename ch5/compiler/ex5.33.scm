(load "ch5/compiler/compiler.scm")

(compile '(define (factorial n)
            (if (= n 1)
              1
              (* (factorial (- n 1)) n))
            )
  'val
  'next
  )

(debug)
H