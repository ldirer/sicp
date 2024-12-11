(load "ch4/4.4.logic/data_jobs.scm")

;should not raise an error (no rules here)
(or (supervisor (Bitdiddle Ben) ?who) (supervisor (Bitdiddle Ben) ?who))


; should not raise an error
(or (outranked-by (Bitdiddle Ben) ?who) (outranked-by (Bitdiddle Ben) ?who))

; broken rule from ex4.64
(assert!
  (rule (outranked-by-wrong ?staff-person ?boss)
    (or
      (supervisor ?staff-person ?boss)
      (and
        (outranked-by-wrong ?middle-manager ?boss)
        (supervisor ?staff-person ?middle-manager)
        )
      )
    )
  )

; should raise an error instead of looping indefinitely.
(outranked-by-wrong (Bitdiddle Ben) ?who)
