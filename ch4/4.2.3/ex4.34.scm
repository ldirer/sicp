; don't reload lazy... because it reload the 'interpreter preload' that redefines `apply-in-underlying-scheme`...
; this is all pretty fragile...
;(load "ch4/4.2.2/lazy.scm")

; useful: reading the entirety of the exercise question before jumping in...
; > You may also need to modify the representation of lazy pairs so that
; > the evaluator can identify them in order to print them.


(define (user-print object)
  ; the code guarantees we never get here with `object` a `thunk`.
  ; otherwise we'd need to adjust, because we can't `display` our environment objects (may contain circular references).
  ; ex circular reference: whenever a procedure is defined, the value of the procedure will contain a reference
  ; to the environment where it is defined, that's a loop.
  (cond
    ((lazy-list? object) (user-print-lazy-list object 0))
    ((compound-procedure? object) (user-print-procedure object))
    (else (display object))
    )
  )


(define (user-print-procedure object)
  (display (list 'compound-procedure
                 (procedure-parameters object)
                 (procedure-body object)
                 '<procedure-env>
             ))
  )

; Two worlds: behind the interpreter. In front of the interpreter.
; I'm a bit unsure which objects stand where sometimes
(define (user-print-lazy-list object count)
  (define (helper object)
    (define env (procedure-environment object))
    ; this should be like (car object) except car here is the native car and object is our lazy list expression.
    ; todo: let's see if this crashes? setup test loop.
    (define x (lookup-variable-value 'x env))
    (define y (lookup-variable-value 'y env))
    (define open-parens (= count 0))
    (if open-parens (display "("))
    (define close-parens (null? y))

    (user-print-thunk x)
    (display " ")
    (user-print-lazy-list (force-it y) (+ count 1))
    (if close-parens (display ")"))
    )
  (if
    (< 9 count)
    (display "...")
    (helper object)
    )
  )

(define (user-print-thunk obj)
  (cond
    ((evaluated-thunk? obj) (user-print (evaluated-thunk-value obj)))
    ((thunk? obj) (user-print (thunk-expr obj)))
    (else error "should not have gotten there, obj is not a thunk. obj=" obj)
    )
  )

; QUESTION: how do we make lazy lists identifiable?
; they are lambdas before this exercise.
; Having a `lazy-list?` method (something that the lambda object is applied to) will always be problematic if it runs on any object that looks like a procedure.
; If it involves running the object-procedure, non-lazy-lists objects will crash (also this might have side effects).
; So we need to attach the information to the lambda somehow.
; I'm thinking we could name the lambda or the parameter in a special way... That's about it.

; note this belongs to the interpreter 'backend', unlike the rest of the lazy list implementation.
; at least the way I did it :).
(define (lazy-list? obj)
  (and
    (compound-procedure? obj)
    ; need to use the relevant comparison method (equal?)
    (equal? (procedure-parameters obj) (list 'METHOD-LAZY-LIST))
    )
  )
