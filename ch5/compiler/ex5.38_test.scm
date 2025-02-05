(load "ch5/compiler/compiler.scm")
(load "ch5/compiler/utils.scm")
(load "testing.scm")
(load "ch5/compiler/compile_and_go.scm")

;(compile '(f 1 2) 'val 'next)
;(spread-arguments '(1 2))
;
;; error too many operands
;;(spread-arguments '(1 2 3 4))

;(display-list (statements (spread-arguments '(1 (+ 2 3)))))
;(display-list (statements (spread-arguments '((f 1) 2))))

(check-equal "basic"
  (statements (compile '(+ 1 2) 'val 'next))
  '(
     (assign arg1 (const 1))
     (assign arg2 (const 2))
     (assign val (op +) (reg arg1) (reg arg2)))
  )

(define expected '(
                    (assign arg1 (const 2))
                    (save arg1)
                    (assign arg1 (const 1))
                    (assign arg2 (const 1))
                    (assign arg2 (op +) (reg arg1) (reg arg2))
                    (restore arg1)
                    (assign val (op +) (reg arg1) (reg arg2))
                    ))
;(display-instruction-comparison
;  expected
;  (statements (compile '(+ 2 (+ 1 1)) 'val 'next))
;  )
;(display-list
;  (statements (compile '(+ 2 (+ 1 1)) 'val 'next))
;  )
(check-equal "save and restore correctly inserted" (statements (compile '(+ 2 (+ 1 1)) 'val 'next)) expected)


; I'm a bit confused as to env modifications that might happen when evaluating operands
; I think there's a bug where we don't restore env after assigning it a compiled procedure env.
; That bug would cause (define (f x) x) (+ (f 2) x) to return 4 instead of an error...
; The plan is to make the compiled code run so I can test it, then come back to this.
; -> There was such a bug. Fixed.
(display-list (statements
                (compile
                  '(begin
                     (define (f x) (+ x 1))
                     (+ (f 2) x)
                     )
                  'val
                  'next
                  )))
; TODO new method to compile and just run print result. No repl
;(compile-and-go '(begin
;                     (define (f x) (+ x 1))
;                     (+ (f 2) x)
;                     ))

; should also raise an error.
;(compile-and-go '(begin
;                     (define (f x) (+ x 1))
;                     (+ 1 (f 2))
;                     x
;                     ))


; TODO test with (+ 1 2 3 4 5)               ; do the compile and just print result thing. WRITING CODE TO LEARN TO WRITE CODE FASTER. THIS IS THE WAY.
; test with:
;(define x 1)
;(define (f x) (+ x 1))
;(+ 1 2 (f 10) x)
; expected 3+11+1=15