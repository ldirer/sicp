(load "ch4/4.4.logic/data_jobs.scm")
; next-to relation that finds adjacent elements in a list


; note there is no body - the conclusion holds true for all matching variables
(assert!
  (rule (?x next-to ?y in (?x ?y . ?u)))
  )
; the rules work together, ?v _could_ be the same as ?x and the rule below might miss valid matches.
; But then we would match the first rule.
(assert!
  (rule (?x next-to ?y in (?v . ?z))
    (?x next-to ?y in ?z))
  )


; Exercise: What will the response be to the following queries?

(?x next-to ?y in (1 (2 3) 4))
; expected:
; ((2 3) next-to 4 in (1 (2 3) 4))
; (1 next-to (2 3) in (1 (2 3) 4))


(?x next-to 1 in (2 1 3 1))
; expected:
; (3 next-to 1 in (2 1 3 1))
; (2 next-to 1 in (2 1 3 1))

; correct. I initially had the order wrong.
