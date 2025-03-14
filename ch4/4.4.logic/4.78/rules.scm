; code from section 4.4.4.4

(define (apply-rules pattern frame)
  (define rule (fetch-rules pattern frame))
  (apply-a-rule rule pattern frame)
  )


(define (apply-a-rule rule query-pattern query-frame)
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result
            (unify-match query-pattern (conclusion clean-rule)
              query-frame)))
      (require (not (eq? unify-result 'failed)))
      (qeval (rule-body clean-rule) unify-result)
      )
    )
  )


(define (rename-variables-in rule)
  (let ((rule-application-id (new-rule-application-id)))
    (define (tree-walk exp)
      (cond
        ((var? exp) (make-new-variable exp rule-application-id))
        ((pair? exp) (cons
                       (tree-walk (car exp))
                       (tree-walk (cdr exp))
                       )
          )
        (else exp)
        )
      )
    (tree-walk rule))
  )



(define (unify-match p1 p2 frame)
  (cond
    ((eq? frame 'failed) 'failed)
    ((equal? p1 p2) frame)
    ((var? p1) (extend-if-possible p1 p2 frame))
    ((var? p2) (extend-if-possible p2 p1 frame)) ; extra code compared with pattern matching
    ((and (pair? p1) (pair? p2)) (unify-match
                                   (cdr p1)
                                   (cdr p2)
                                   (unify-match (car p1) (car p2) frame)))
    (else 'failed)
    )
  )

(define (extend-if-possible var val frame)
  (let ((binding (binding-in-frame var frame)))
    (cond
      (binding (unify-match (binding-value binding) val frame))
      ((var? val)
        (let ((binding (binding-in-frame val frame)))
          (if binding
            (unify-match var (binding-value binding) frame)
            (extend var val frame))))
      ((depends-on? val var frame) 'failed)   ; prevent cycles (ex: matching (?x ?x) with (?y (1 ?y)))
      (else (extend var val frame))
      )
    )
  )

(define (depends-on? exp var frame)
  (define (tree-walk e)
    (cond
      ((var? e) (if (eq? e var)
                  true
                  (let ((b (binding-in-frame e frame)))
                    (if b
                      (tree-walk (binding-value b))
                      false
                      )
                    )
                  )
        )
      ((pair? e) (or
                   (tree-walk (car e))
                   (tree-walk (cdr e))
                   ))
      (else false)
      )
    )

  (tree-walk exp)
  )