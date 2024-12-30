(load "ch4/4.4.logic/data_jobs.scm")

;(debug-logic)
;should not trigger loop detection (no rules here)
(or (supervisor (Bitdiddle Ben) ?who) (supervisor (Bitdiddle Ben) ?who))


; should not trigger loop detection
(or (outranked-by (Bitdiddle Ben) ?who) (outranked-by (Bitdiddle Ben) ?who))

; should trigger loop detection and not loop indefinitely
(assert!
  (rule (loopy ?staff-person)
    (loopy ?staff-person)
    )
  )

;(loopy (Bitdiddle Ben))

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

;(outranked-by-wrong (Bitdiddle Ben) ?who)


;; Loop not detected?
;(assert!
;  (rule (loopy-2 ?staff-person)
;    (and (supervisor ?one ?two)
;    (loopy-2 ?one))
;    )
;  )
;(loopy-2 (Bitdiddle Ben))
;
;
