(define (unless condition usual-value exceptional-value)
  error "it was a trap all along!"
  (if condition exceptional-value usual-value)
  )

(define (factorial n)
  (if
    (= n -100)
    "don't multiply me, I'm not the correct type!"
    ; below entire body from the book
    (unless
      (= n 1)
      (* n (factorial (- n 1)))
      1)
    )
  )

;(factorial 5) will recurse indefinitely because arguments passed to `unless` are evaluated before the function is called.
; so we will not even enter unless once.
; In a normal language, this definition would be fine.
(factorial 5)