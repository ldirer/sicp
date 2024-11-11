(load "ch4/4.2.2/repl_setup.scm")
; overwrite the output print function
; this one needs to avoid reloading some things
(load "ch4/4.2.3/ex4.34.scm")


; not sure how to test repl output without a repl...
(define obj (eval '(begin
                     (load "ch4/4.2.3/ex4.34_lazylist.scm")
                     (cons 1 (cons 2 (cons (+ 1 1) nil)))
;                     (cons 7 (cons
;                               (+ 1 1)
;                               (cons
;                                 (cons (* "lazy" 3) nil)
;                                 nil
;                                 )
;                               )
;                       )
                     )
              the-global-environment))

(user-print obj)


(eval '(define ones (cons 1 ones)) the-global-environment)

(user-print (eval 'ones the-global-environment))

(display "CURRENTLY BROKEN IMPLEMENTATION")
; I initially interpreted the "print a lazy list" as printing without force-ing every item.
; After doing it, I realize it is not as useful as I thought. Implicit (recursive) definitions are printed as they are, like (1 ones).
; Not too helpful.
; Instead we should probably print a fixed number of items. Max depth too maybe if we have nested lists.

