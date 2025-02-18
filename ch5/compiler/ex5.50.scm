; > Use the compiler to compile the metacircular evaluator of section 4.1 and run this program using the register-machine simulator.

; Can be run with: rlwrap scheme --load "ch5/compiler/ex5.50.scm"
; BUT it's better to use: scheme < "ch5/compiler/ex5.50.scm"
; as this file mixes regular scheme and lines that should be fed to the repl launched by this file.
; Using input redirection we see the returned value from compile-and-run, which can be "unbound-variable . list". Invaluable.
; (tooling could be improved :))
; When running with --load an error can just silently exit the program:
;;;; M-Eval input:
;;(1)
;;... done

(load "ch5/compiler/compile_and_run.scm")
(load "ch5/compiler/utils.scm")

(define (load-as-symbols filename)
  (let ((input-port (open-input-file filename)))
    (let loop ((expr (read input-port)))
      (if (eof-object? expr)
        (begin
          (close-input-port input-port)
          '()
          )
        (begin
          (cons expr
            (loop (read input-port)))))))
  )


; we can't pass `map` as a primitive because it would receive custom procedure objects. That's the topic of an exercise in chapter 4.
; we can define it in 'standard library' instead, so no modification to the interpreter is required.
; idea from https://www.inchmeal.io/sicp/ch-5/ex-5.50.html
(define stdlib '(begin
                  (define (apply proc args) (apply-special-form proc args))
                  (define (map func items)
                    (if (null? items)
                      '()
                      (cons (func (car items)) (map func (cdr items)))
                      )
                    )
                  )
  )

(define chapter4-code (load-as-symbols "ch4/4.3.1.amb/third_party/mceval.scm"))

; We need ONE expression. stdlib is ONE expression (a sequence).
; we don't want to end up with (begin begin (define...)) as this would try to compile begin #2 as a variable.
(define evaluator-code (cons 'begin (cons stdlib chapter4-code)))

; Two types of error:
; - errors when compiling
; - errors emitted by the evaluator code at runtime
; Annoyingly the stacktrace from evaluator code will always refer to executing a register-machine instruction. Not very helpful!
(compile-and-run evaluator-code)


;; meant to run in the evaluator REPL ran by the register machine.
(list 1 2 3)
(define var 1)
(define (f n) (+ n 1))
(f 50)
(define (factorial n) (if (= n 1) 1 (* (factorial (- n 1)) n)))
(factorial 5)
