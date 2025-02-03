(load "ch5/compiler/compiler.scm")

(define factorial-iter-code
  (compile '(define (factorial n)
              (define (iter product n)
                (if (> counter n)
                  product
                  (iter (* counter product) (+ counter 1))
                  )
                )
              (iter 1 1)
              )
    'val
    'next
    ))

(define (display-newline a) (newline) (display a))
(define (display-list items)
  (for-each display-newline items)
  )

(display-list (statements factorial-iter-code))

; the `diff` with the recursive factorial instructions is large, not very helpful.
; I annotated the instructions.
; Here's another explanation, nice: https://www.inchmeal.io/sicp/ch-5/ex-5.34.html