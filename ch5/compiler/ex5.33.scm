(load "ch5/compiler/compiler.scm")

(define factorial-code (compile '(define (factorial n)
            (if (= n 1)
              1
              (* (factorial (- n 1)) n))
            )
  'val
  'next
  ))
(define factorial-alt-code (compile '(define (factorial-alt n)
            (if (= n 1)
              1
              (* n (factorial-alt (- n 1))))
            )
  'val
  'next
  ))

(define (display-newline a) (newline) (display a))
(define (display-list items)
  (for-each display-newline items)
  )

(display-list (statements factorial-code))
(display-list (statements factorial-alt-code))

; Here's the diff in instructions (edited to remove irrelevant factorial vs factorial-alt differences):

;(base) laurent@pop-os:~/programming/sicp (main)diff ch5/compiler/ex5.33_factorial_*
;33,34c33,36
;< (save env)
;< (assign proc (op lookup-variable-value) (const factorial-alt) (reg env))
;---
;> (assign val (op lookup-variable-value) (const n) (reg env))
;> (assign argl (op list) (reg val))
;> (save argl)
;> (assign proc (op lookup-variable-value) (const factorial) (reg env))
;61,63c63
;< (assign argl (op list) (reg val))
;< (restore env)
;< (assign val (op lookup-variable-value) (const n) (reg env))
;---
;> (restore argl)


; the alt version saves env, while the original one saves argl.
; I don't think there's a significant difference. Same number of stack operations.