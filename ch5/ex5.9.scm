; original operation exps
;(define (make-operation-exp exp machine labels operations)
;  (let (
;         (op (lookup-prim (operation-exp-op exp) operations))
;         (aprocs
;           (map
;             (lambda (e) (make-primitive-exp e machine labels))
;             (operation-exp-operands exp)
;             )
;           )
;         )
;    (lambda ()
;      (apply op (map (lambda (p) (p)) aprocs))
;      )
;    )
;  )

; modified operation exps - I kept that one in the code imported everywhere else.
(define (make-operation-exp exp machine labels operations)
  (let (
         (op (lookup-prim (operation-exp-op exp) operations))
         (aprocs
           (map
             (lambda (e)
               (if (not (or (constant-exp? e) (register-exp? e)))
                 (error "operations can only be used on constants or the contents of register -- ASSEMBLE" e)
                 )
               (make-primitive-exp e machine labels)
               )
             (operation-exp-operands exp)
             )
           )
         )
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs))
      )
    )
  )

