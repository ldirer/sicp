(load "ch4/4.1.4/primitives.scm")


; handle thunk objects to avoid infinite printing of circular references (normal order evaluation, ex5.25)
(define (user-print object)
  (cond
    ((compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>
                 )))
    ((thunk? object) (display (list 'thunk (thunk-expr object) '<thunk-env>)))
    ((compiled-procedure? object) (display '<compiled-procedure>))
    (else (display object))
    )
  )

