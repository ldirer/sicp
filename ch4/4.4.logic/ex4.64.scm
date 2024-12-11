(load "ch4/4.4.logic/data_jobs.scm")


; Louis makes a mistake and types:
(assert!
  (rule (outranked-by-wrong ?staff-person ?boss)
    (or
      (supervisor ?staff-person ?boss)
      (and
        (outranked-by-wrong ?middle-manager ?boss)
        (supervisor ?staff-person ?middle-manager)
;         (job ?middle-manager ?whatever)
;         (not (same ?staff-person ?middle-manager))
;        (not (same (Bitdiddle Ben) ?middle-manager))
        )
      )
    )
  )

;(outranked-by-wrong ?staff ?boss)
;(debug-logic)
;(outranked-by-wrong (aull dewitt) ?who ?middle-manager)

(outranked-by-wrong (Bitdiddle Ben) ?who)
; the system first answers with the one match from the first 'or' clause: (supervisor ?staff-person ?boss)
; in that matching frame ?boss is bound to (warbucks oliver).
; then it also wants to answer with matches from the second 'or' clause.
; (outranked-by ?middle-manager ?boss) with ?middle-manager and ?boss free (?boss bound to ?who - it's an 'or' so the previous ?boss binding is not relevant)
; this causes an infinite loop.
;
; It does generate a lot of 'valid' frames that are then checked against the second `and` clause.
; There's never a match. And the loop goes on and on.
; A small experiment to check that, replacing the supervisor line:
; (supervisor ?staff-person ?middle-manager)
; with:
; (not (same ?staff-person ?middle-manager))
; I thought we would get lots of outputs. Turns out we only get two:
; (outranked-by-wrong (bitdiddle ben) (warbucks oliver))
; (outranked-by-wrong (bitdiddle ben) (warbucks oliver))
; I checked and in the second one, ?middle-manager is bound to (aull dewitt).
; **This is in part due to the behavior of `not` when some variables are unbound**.
; Using:
;  (and
;    (outranked-by-wrong ?middle-manager ?boss)
;    (job ?middle-manager ?whatever)
;    (not (same (Bitdiddle Ben) ?middle-manager))
;    )
; we get an infinite stream as output.

; DETAILS ON HOW THE INFINITE LOOP HAPPENS:
; We left things at:
; (outranked-by ?middle-manager ?boss) with ?middle-manager and ?boss free (?boss bound to ?who - it's an 'or' so the previous ?boss binding is not relevant)
; the first clause in the `or` will yield many valid frames.
; mostly irrelevant _here_: due to how we evaluate 'or' operands (interleaving the streams) we only take the first one before asking one from the second operand ('and').
; The real reason we get the infinite loop *without results* is that the second condition rejects them all. That's all there is to it!
; I got quite a bit confused by that, and tripped on the behavior of 'not' with unbound variables.
;