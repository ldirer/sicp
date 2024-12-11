(load "ch4/4.4.logic/data_jobs.scm")


; termination condition
(assert!
  (rule (last-pair (?last) (?last)))
  )

; recursion: last-pair of cons x more if last pair of more
(assert!
  (rule (last-pair (?x . ?more) (?last))
    (last-pair ?more (?last))
    )
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


; adding 'display' statements to the code. Reminder that (? 19 last) is how ?last-19 is represented.
; the first line of each log shows the conclusion of the rule it's matching against.
;(last-pair ?x (3))
;;;; Query results:
;unify-match, p1=(last-pair (? x) (3)) p2=(last-pair ((? 19 last)) ((? 19 last)))
;unify-match, p1=last-pair p2=last-pair
;unify-match, p1=((? x) (3)) p2=(((? 19 last)) ((? 19 last)))
;unify-match, p1=(? x) p2=((? 19 last))
;unify-match, p1=((3)) p2=(((? 19 last)))
;unify-match, p1=(3) p2=((? 19 last))
;unify-match, p1=3 p2=(? 19 last)
;unify-match, p1=() p2=()
;unify-match, p1=() p2=()
;
;(last-pair (3) (3))
;
;unify-match, p1=(last-pair (? x) (3)) p2=(last-pair ((? 20 x) ? 20 more) ((? 20 last)))
;unify-match, p1=last-pair p2=last-pair
;unify-match, p1=((? x) (3)) p2=(((? 20 x) ? 20 more) ((? 20 last)))
;unify-match, p1=(? x) p2=((? 20 x) ? 20 more)                    -- This is ?x = (?x-20 . ?more-20). The rest of the lines figure out that ?more-20 = (3).
;unify-match, p1=((3)) p2=(((? 20 last)))
;unify-match, p1=(3) p2=((? 20 last))
;unify-match, p1=3 p2=(? 20 last)
;unify-match, p1=() p2=()
;unify-match, p1=() p2=()
;unify-match, p1=(last-pair (? 20 more) ((? 20 last))) p2=(last-pair ((? 21 last)) ((? 21 last)))
;unify-match, p1=last-pair p2=last-pair
;unify-match, p1=((? 20 more) ((? 20 last))) p2=(((? 21 last)) ((? 21 last)))
;unify-match, p1=(? 20 more) p2=((? 21 last))
;unify-match, p1=(((? 20 last))) p2=(((? 21 last)))
;unify-match, p1=((? 20 last)) p2=((? 21 last))
;unify-match, p1=(? 20 last) p2=(? 21 last)
;unify-match, p1=3 p2=(? 21 last)
;unify-match, p1=() p2=()
;unify-match, p1=() p2=()
;
;(last-pair (?x-20 3) (3))
;;..start of next match




; Logs with rules in the other order (termination first). The code never prints any result.
;(last-pair ?x (3))
;;;; Query results:
;unify-match, p1=(last-pair (? x) (3)) p2=(last-pair ((? 19 x) ? 19 more) ((? 19 last)))
;unify-match, p1=last-pair p2=last-pair
;unify-match, p1=((? x) (3)) p2=(((? 19 x) ? 19 more) ((? 19 last)))
;unify-match, p1=(? x) p2=((? 19 x) ? 19 more)
;unify-match, p1=((3)) p2=(((? 19 last)))
;unify-match, p1=(3) p2=((? 19 last))
;unify-match, p1=3 p2=(? 19 last)
;unify-match, p1=() p2=()
;unify-match, p1=() p2=()
;unify-match, p1=(last-pair (? 19 more) ((? 19 last))) p2=(last-pair ((? 20 x) ? 20 more) ((? 20 last)))
;unify-match, p1=last-pair p2=last-pair
;unify-match, p1=((? 19 more) ((? 19 last))) p2=(((? 20 x) ? 20 more) ((? 20 last)))
;unify-match, p1=(? 19 more) p2=((? 20 x) ? 20 more)
;unify-match, p1=(((? 19 last))) p2=(((? 20 last)))
;unify-match, p1=((? 19 last)) p2=((? 20 last))
;unify-match, p1=(? 19 last) p2=(? 20 last)
;unify-match, p1=3 p2=(? 20 last)
;unify-match, p1=() p2=()
;unify-match, p1=() p2=()
;unify-match, p1=(last-pair (? 20 more) ((? 20 last))) p2=(last-pair ((? 21 x) ? 21 more) ((? 21 last)))
;unify-match, p1=last-pair p2=last-pair
;unify-match, p1=((? 20 more) ((? 20 last))) p2=(((? 21 x) ? 21 more) ((? 21 last)))
;unify-match, p1=(? 20 more) p2=((? 21 x) ? 21 more)
;unify-match, p1=(((? 20 last))) p2=(((? 21 last)))
;unify-match, p1=((? 20 last)) p2=((? 21 last))
;unify-match, p1=(? 20 last) p2=(? 21 last)
;unify-match, p1=3 p2=(? 21 last)
;unify-match, p1=() p2=()
;unify-match, p1=() p2=()
;unify-match, p1=(last-pair (? 21 more) ((? 21 last))) p2=(last-pair ((? 22 x) ? 22 more) ((? 22 last)))
;unify-match, p1=last-pair p2=last-pair
;unify-match, p1=((? 21 more) ((? 21 last))) p2=(((? 22 x) ? 22 more) ((? 22 last)))
;unify-match, p1=(? 21 more) p2=((? 22 x) ? 22 more)
;unify-match, p1=(((? 21 last))) p2=(((? 22 last)))
;unify-match, p1=((? 21 last)) p2=((? 22 last))
;unify-match, p1=(? 21 last) p2=(? 22 last)
;unify-match, p1=3 p2=(? 22 last)
;unify-match, p1=() p2=()
;unify-match, p1=() p2=()
;unify-match, p1=(last-pair (? 22 more) ((? 22 last))) p2=(last-pair ((? 23 x) ? 23 more) ((? 23 last)))
;unify-match, p1=last-pair p2=last-pair
;unify-match, p1=((? 22 more) ((? 22 last))) p2=(((? 23 x) ? 23 more) ((? 23 last)))
;unify-match, p1=(? 22 more) p2=((? 23 x) ? 23 more)
;unify-match, p1=(((? 22 last))) p2=(((? 23 last)))
;unify-match, p1=((? 22 last)) p2=((? 23 last))
;unify-match, p1=(? 22 last) p2=(? 23 last)
;unify-match, p1=3 p2=(? 23 last)
;unify-match, p1=() p2=()
;unify-match, p1=() p2=()
;unify-match, p1=(last-pair (? 23 more) ((? 23 last))) p2=(last-pair ((? 24 x) ? 24 more) ((? 24 last)))
;unify-match, p1=last-pair p2=last-pair
;unify-match, p1=((? 23 more) ((? 23 last))) p2=(((? 24 x) ? 24 more) ((? 24 last)))
;unify-match, p1=(? 23 more) p2=((? 24 x) ? 24 more)
;unify-match, p1=(((? 23 last))) p2=(((? 24 last)))
;unify-match, p1=((? 23 last)) p2=((? 24 last))
;unify-match, p1=(? 23 last) p2=(? 24 last)
;unify-match, p1=3 p2=(? 24 last)
;unify-match, p1=() p2=()
;unify-match, p1=() p2=()
;unify-match, p1=(last-pair (? 24 more) ((? 24 last))) p2=(last-pair ((? 25 x) ? 25 more) ((? 25 last)))
;unify-match, p1=last-pair p2=last-pair


; We can see where the loop happens exactly. This is the operation we repeat:
;unify-match, p1=(last-pair (? 22 more) ((? 22 last))) p2=(last-pair ((? 23 x) ? 23 more) ((? 23 last)))
; We never see ?more-22 as a one-item list since we match it with the first (non-terminal) rule first, and that matching tries to match more-23, and so on.

