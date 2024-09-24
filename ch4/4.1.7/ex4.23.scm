(load "ch4/4.1.7/eval.scm")

; Alyssa P. Hacker version
(define (alternative-analyze-sequence exps)
  (define (execute-sequence procs env)
    (cond ((null? (cdr procs))
            ((car procs) env))
      (else
        ((car procs) env)
        (execute-sequence (cdr procs) env))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
      (error "Empty sequence: ANALYZE"))
    (lambda (env)
      (execute-sequence procs env))))

;From the book:
;Compare the two versions of analyze-sequence. For ex-
;ample, consider the common case (typical of procedure bod-
;ies) where the sequence has just one expression. What work
;will the execution procedure produced by Alyssa’s program
;do? What about the execution procedure produced by the
;program in the text above? How do the two versions com-
;pare for a sequence with two expressions?

; 1. Sequence with just one expression.
; With Alyssa's version, the execution procedure will run (execute-sequence (list single-proc) env).
; There will be one call to execute-sequence.

; With the original version from the book, the procedure will be executed directly: (single-proc env)

; 2. With two expressions
; Alyssa: a recursive call to execute-sequence is made.
; This includes the conditional checks to to see if there are still elements in the list.
; Original: single call to a procedure that calls the two 'analyzed' procedures.

; With many expressions it looks like the original version will produce a lambda with many nested lambdas.
; We save the (null? ..) evaluations that are part of Alyssa's version.


