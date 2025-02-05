; in exercise 5.9 we added error handling on operations used with labels as arguments .
; I used that throughout in assembler.scm (useful!).
; but now our compiler produces such code, so we revert to the version without error handling.
(define (make-operation-exp exp machine labels operations)
  (let (
         (op (lookup-prim (operation-exp-op exp) operations))
         (aprocs
           (map
             (lambda (e) (make-primitive-exp e machine labels))
             (operation-exp-operands exp)
             )
           )
         )
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs))
      )
    )
  )

