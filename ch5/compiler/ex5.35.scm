(load "testing.scm")
(load "ch5/compiler/compiler.scm")
(load "ch5/compiler/utils.scm")
; a mystery!
;> What expression was compiled to produce the code shown in figure 5.18?
; I copied the code and then reformatted with AI to have one line per instruction.
; Mentioning JUST IN CASE IT DECIDED TO HACK AN INSTRUCTION.

; solution:
; (define (f x) (+ x (g (+ x 2))))

(define mystery-instructions
  '(
     (assign val (op make-compiled-procedure) (label entry16) (reg env))                       ; procedure definition
     (goto (label after-lambda15))                                                             ; the two lines in after-lambda15 tell us it's a (define (f))
     entry16                                                                                   ; body of procedure
     (assign env (op compiled-procedure-env) (reg proc))
     (assign env (op extend-environment) (const (x)) (reg argl) (reg env))                     ; arguments: (x)
     (assign proc (op lookup-variable-value) (const +) (reg env))
     (save continue)
     (save proc)
     (save env)
     (assign proc (op lookup-variable-value) (const g) (reg env))                              ; new player g
     (save proc)
     (assign proc (op lookup-variable-value) (const +) (reg env))
     (assign val (const 2))
     (assign argl (op list) (reg val))
     (assign val (op lookup-variable-value) (const x) (reg env))
     (assign argl (op cons) (reg val) (reg argl))
     (test (op primitive-procedure?) (reg proc))
     (branch (label primitive-branch19))
     compiled-branch18
     (assign continue (label after-call17))
     (assign val (op compiled-procedure-entry) (reg proc))
     (goto (reg val))
     primitive-branch19
     (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
     after-call17
     (assign argl (op list) (reg val))                                                         ; argl: single item, restult of (+ x 2)
     (restore proc)                                                                            ; proc<-g
     (test (op primitive-procedure?) (reg proc))
     (branch (label primitive-branch22))
     compiled-branch21
     (assign continue (label after-call20))
     (assign val (op compiled-procedure-entry) (reg proc))
     (goto (reg val))
     primitive-branch22
     (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
     after-call20
     (assign argl (op list) (reg val))                                                         ; argl: single item, result of (g ..)
     (restore env)
     (assign val (op lookup-variable-value) (const x) (reg env))
     (assign argl (op cons) (reg val) (reg argl))                                              ; argl: (x result-of-g)
     (restore proc)                                                                            ; proc<-+
     (restore continue)
     (test (op primitive-procedure?) (reg proc))
     (branch (label primitive-branch25))
     compiled-branch24
     (assign val (op compiled-procedure-entry) (reg proc))
     (goto (reg val))
     primitive-branch25
     (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
     (goto (reg continue))
     after-call23
     after-lambda15
     (perform (op define-variable!) (const f) (reg val) (reg env))
     (assign val (const ok))
     )
  )


(define guess '(define (f x) (+ x (g (+ x 2)))))
(define label-counter 14)
(define compiled-guess (statements (compile guess 'val 'next)))

(display
   (zip
      compiled-guess
      mystery-instructions
      )
   )

(display-list (map
                (lambda (pair) (let ((a (car pair)) (b (cadr pair))) (if (equal? a b) (list 'ok a) (list 'NOK a b))))
                (zip
                  compiled-guess
                  mystery-instructions
                  )
                )
  )
;(check-equal "mystery solved?" compiled-guess mystery-instructions)
