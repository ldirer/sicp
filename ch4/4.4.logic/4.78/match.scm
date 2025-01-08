; Pattern matching - code from section 4.4.4.3
(load "ch4/4.4.logic/frames.scm")
(load "ch4/4.4.logic/syntax.scm")

(define (find-assertions pattern frame)
  (define datum (fetch-assertions pattern frame))
  (check-an-assertion datum pattern frame)
  )

(define (check-an-assertion assertion query-pat query-frame)
  (let ((match-result (pattern-match query-pat assertion query-frame)))
    (require (not (eq? match-result 'failed)))
    match-result
    )
  )

(define (pattern-match pat dat frame)
  (cond
    ((eq? frame 'failed) 'failed)
    ((equal? pat dat) frame)
    ((var? pat) (extend-if-consistent pat dat frame))
    ((and (pair? pat) (pair? dat))
      (pattern-match (cdr pat) (cdr dat) (pattern-match (car pat) (car dat) frame))
      )
    (else 'failed)
    )
  )


(define (extend-if-consistent var dat frame)
  (let ((binding (binding-in-frame var frame)))
    (if binding
      (pattern-match (binding-value binding) dat frame)
      (extend var dat frame)
      )
    )
  )