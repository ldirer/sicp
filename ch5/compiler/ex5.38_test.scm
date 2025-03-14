(load "ch5/compiler/compiler_lexical_addressing.scm")
(load "ch5/compiler/utils.scm")
(load "testing.scm")
(load "ch5/compiler/compile_and_run.scm")
(load "ch5/compiler/compiler_environment.scm")

;(compile '(f 1 2) 'val 'next the-empty-compiler-environment)
;(spread-arguments '(1 2) the-empty-compiler-environment)
;
;; error too many operands
;;(spread-arguments '(1 2 3 4) the-empty-compiler-environment)

;(display-list (statements (spread-arguments '(1 (+ 2 3)) the-empty-compiler-environment)))
;(display-list (statements (spread-arguments '((f 1) 2)) the-empty-compiler-environment))

(check-equal "basic"
  (statements (compile '(+ 1 2) 'val 'next the-empty-compiler-environment))
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
;(display-instruction-comparison expected (statements (compile '(+ 2 (+ 1 1)) 'val 'next)))
;(display-list (statements (compile '(+ 2 (+ 1 1)) 'val 'next)))
(check-equal "save and restore correctly inserted" (statements (compile '(+ 2 (+ 1 1)) 'val 'next the-empty-compiler-environment)) expected )


; I'm a bit confused as to env modifications that might happen when evaluating operands
; I think there's a bug where we don't restore env after assigning it a compiled procedure env.
; That bug would cause (define (f x) x) (+ (f 2) x) to return 4 instead of an error...
; The plan is to make the compiled code run so I can test it, then come back to this.
; -> There was such a bug. Fixed.
;(display-list (statements
;                (compile
;                  '(begin
;                     (define (f x) (+ x 1))
;                     (+ (f 2) x)
;                     )
;                  'val
;                  'next
;                  )))

; should raise an error
(compile-and-run '(begin
                     (define (f x) (+ x 1))
                     (+ (f 2) x)
                     ))

;; should also raise an error.
;; I think the fact that I wrote this test highlights a misunderstanding of how instruction sequences are combined.
;; Basically it's impossible to mess up the *next expression* just by writing the compile function for an open-coded primitives.
;; the guarantees that env does not leak are provided by code written elsewhere (in compile-sequence).
;(compile-and-run '(begin
;                     (define (f x) (+ x 1))
;                     (+ 1 (f 2))
;                     (+ x 1)
;                     ))


(check-equal "correctness more than 2 operands with +" (compile-and-run '(+ 1 2 3 4 5)) 15)
(check-equal "correctness more than 2 operands with +, preserving env"
  (compile-and-run
    '(begin
       (define x 1)
       (define (f x) x)
       (+ 1 x (f 10) x)
       ))
  13
  )

(check-equal "instruction list for more than 2 operands with +" (statements (compile '(+ 1 2 3 4 5) 'val 'next the-empty-compiler-environment))
  '(
     (assign arg1 (const 1))
     (assign arg2 (const 2))
     (assign arg1 (op +) (reg arg1) (reg arg2))
     (assign arg2 (const 3))
     (assign arg1 (op +) (reg arg1) (reg arg2))
     (assign arg2 (const 4))
     (assign arg1 (op +) (reg arg1) (reg arg2))
     (assign arg2 (const 5))
     (assign val (op +) (reg arg1) (reg arg2))
     )
  )
