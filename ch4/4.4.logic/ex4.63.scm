; use logic
(assert! (son Adam Cain))
(assert! (son Cain Enoch))
(assert! (son Enoch Irad))
(assert! (son Irad Mehujael))
(assert! (son Mehujael Methushael))
(assert! (son Methushael Lamech))
(assert! (wife Lamech Ada))
(assert! (son Ada Jabal))
(assert! (son Ada Jubal))

; "if S is the son of F, and F is the son of G, then S is the grandson of G"
; "if W is the wife of M, and S is the son of W, then S is the son of M"

; rules
(assert!
  (rule (grandson ?G ?S)
    (and
      (son ?F ?S)
      (son ?G ?F)
      )
    )
  )

; note how we can create a rule named son that relies on assertions with the same name.
(assert!
  (rule (son ?M ?S)
      (and
        (wife ?M ?W)
        (son ?W ?S)
        )
    )
  )

; sanity check
;(son Methushael ?S)

; queries:
(grandson Cain ?S)
; results
;(grandson cain irad)
(son Lamech ?S)
; results
;(son lamech jubal)
;(son lamech jabal)

(grandson Methushael ?S)
; results
;(grandson methushael jubal)
;(grandson methushael jabal)
