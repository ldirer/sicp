(load "ch4/interpreter_rules.scm")  ; let->combination

(define (analyze-let exp)
  (analyze (let->combination exp))
  )
