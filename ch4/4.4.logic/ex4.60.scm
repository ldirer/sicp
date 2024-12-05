; use logic
(load "ch4/4.4.logic/data_jobs.scm")

(lives-near ?person (Hacker Alyssa P))
;;;; Query results:
;(lives-near (fect cy d) (hacker alyssa p))


(lives-near ?person-1 ?person-2)
;;;; Query results:
;(lives-near (aull dewitt) (reasoner louis))
;(lives-near (aull dewitt) (bitdiddle ben))
;(lives-near (reasoner louis) (aull dewitt))
;(lives-near (reasoner louis) (bitdiddle ben))
;(lives-near (hacker alyssa p) (fect cy d))
;(lives-near (fect cy d) (hacker alyssa p))
;(lives-near (bitdiddle ben) (aull dewitt))
;(lives-near (bitdiddle ben) (reasoner louis))


; As the exercise mentions, each pair is listed twice.
; All of these assertions match the given query.
; the rule does not really care about 'person1' and 'person2', it just tries to match all values.

; we could deduplicate with what feels like a bit of a hack:
(assert! (rule (lives-near-2 ?person-1 ?person-2)
           (and
             (address ?person-1 (?town . ?rest-1))
             (address ?person-2 (?town . ?rest-2))
             (lisp-value compare-symbol-lists< ?person-1 ?person-2)
             )
           )
  )
; this forces an order on the person pairs.
(lives-near-2 ?person-1 ?person-2)
;; results
;(lives-near-2 (aull dewitt) (reasoner louis))
;(lives-near-2 (aull dewitt) (bitdiddle ben))
;(lives-near-2 (fect cy d) (hacker alyssa p))
;(lives-near-2 (bitdiddle ben) (reasoner louis))
