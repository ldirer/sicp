(load "ch4/4.4.logic/data_jobs.scm")


; recursion: last-pair of cons x more if last pair of more
(assert!
  (rule (last-pair (?x . ?more) (?last))
    (last-pair ?more (?last))
    )
  )
; termination condition
(assert!
  (rule (last-pair (?last) (?last)))
  )



(last-pair (3) ?x)
; expected: (last-pair (3) (3))
; ok

(last-pair (1 2 3) ?x)
; expected: (last-pair (1 2 3) (3))
; ok

(last-pair (2 ?x) (3))
; expected: (last-pair (2 3) (3))
; ok


; Exercise question: Do your rules work correctly on queries such as:
(last-pair ?x (3))
; expected: well I'm not sure.
; I guess we'd want: (last-pair (3) (3)) to begin with.
; then... An infinite stream of random lists with 3 at the end?

; ACTUAL: it hangs. Does not print a single result.
; --> It depends on **the order rules are defined in**.
; If the termination condition is defined **after** the recursive rule, I see output streaming:
;;;; Query results:
;(last-pair (3) (3))
;(last-pair (?x-20 3) (3))
;(last-pair (?x-20 ?x-22 3) (3))
;(last-pair (?x-20 ?x-22 ?x-24 3) (3))
;(last-pair (?x-20 ?x-22 ?x-24 ?x-26 3) (3))
;(last-pair (?x-20 ?x-22 ?x-24 ?x-26 ?x-28 3) (3))
;(last-pair (?x-20 ?x-22 ?x-24 ?x-26 ?x-28 ?x-30 3) (3))
; ...
; This is pretty cool!

; What is happening:
; Query evaluator fetches relevant assertions (none) and rules for query. 2 rules found.
; We've been in the simple-query and apply-rules procedures.
; apply-rules is a flatmap, on streams resulting from apply-a-rule.
; apply-a-rule runs on the first one (termination - the one defined _last_ since we 'cons' it into the stream-database).
; In apply-a-rule we get to:
; (qeval (rule-body clean-rule) (singleton-stream unify-result))
; This gives us (last-pair (3) (3)) (only element of that stream)
; Then we're processing the recursive rule, matching in the conclusion (?x and ?more) remain free at this stage, and recursively matching (last-pair (?more) (?last)).
; - Either we apply the termination rule (binds ?more to (?last)): we get (last-pair (?x-20 3) (3))
; - Or we apply the other one, recursive call. The recursive call happens every other time, hence the +2 in the variable numbering (numbering based on rule application count).
