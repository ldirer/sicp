; use logic
(load "ch4/4.4.logic/data_jobs.scm")



;a. On Friday moring, Ben wants to query the data base for all the meetings that occur that day
(meeting ?division (Friday ?h))
; results:
;(meeting administration (friday |1pm|))

;b.
(assert!
  (rule (meeting-time ?person ?day-and-time)
    (or
      (meeting whole-company ?day-and-time)
      (and
        (job ?person (?division . ?rest1))
        (meeting ?division ?day-and-time)
        )
      )
    )
  )
(meeting-time (Hacker Alyssa P) (Wednesday ?h))
;;; Query results:
;(meeting-time (hacker alyssa p) (wednesday |4pm|))
;(meeting-time (hacker alyssa p) (wednesday |3pm|))


; I find it's a bit tricky to print more things in results.
; we still have to constrain the day and time in the second 'and' clause below when really we already filtered everything.
; there is no automatic "join".
; I think that makes it worth adding more arguments to rules, that are always passed as variables.
(and
  (meeting-time (Hacker Alyssa P) (Wednesday ?h))
  (meeting ?division (Wednesday ?h))
  )
;;;; Query results:
;(and (meeting-time (hacker alyssa p) (wednesday |4pm|)) (meeting whole-company (wednesday |4pm|)))
;(and (meeting-time (hacker alyssa p) (wednesday |3pm|)) (meeting computer (wednesday |3pm|)))


; this does not quite work. I think it shows a misunderstanding in how compound queries work.
; more on that in the next exercises!
;(assert!
;  (rule (meeting-time-2 ?person ?day-and-time ?meeting-args)
;    (and
;      (meeting . ?meeting-args)
;      (or
;        (meeting whole-company ?day-and-time)
;        (and
;          (job ?person (?division . ?rest1))
;          (meeting ?division ?day-and-time)
;          )
;        )
;      )
;    )
;  )
;
;(meeting-time-2 (Hacker Alyssa P) (Wednesday ?h) ?division)