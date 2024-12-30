;(load "ch4/4.4.logic/data_jobs.scm")

;; Chat made me believe this could highlight a bug in a third party implementation... No no.
(assert!
  (rule (ancestor ?x ?y)
    (or
      (parent ?x ?y)
      (and
        (parent ?x ?z)
        (ancestor ?z ?y)
        )
      )
    )
  )

(assert! (parent Alice Bob))
(assert! (parent Bob Carol))

(ancestor ?x ?y)
; expected:
;(ancestor Alice Bob)
;(ancestor Alice Carol)
;(ancestor Bob Carol)


; Then I tried to find a test case where a pattern would be matched multiple times with different frame bindings.
; the history pattern might then have more free variables than the pattern 'at hand' and a loop would be wrongly
; detected if loop detection relies on unify-match (as in the 3rd party code that I don't quite grasp).
; I couldn't come up with an example. Maybe the ancestor one is not bad in that regard.
; we do have (ancestor ?z ?y) that looks like a call we already made, except the bindings restrict values so it's not.
