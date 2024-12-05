; use logic
(load "ch4/4.4.logic/data_jobs.scm")

(assert!
  (rule (is-big-shot ?person ?division)
    (and
      (job ?person (?division . ?rest))
      (not
        (and
          (supervisor ?person ?boss)
          (job ?boss (?division . ?rest2))
          )
        )
      )
    )
  )
(is-big-shot ?person ?division)
; results:
;(is-big-shot (scrooge eben) accounting)
;(is-big-shot (warbucks oliver) administration)
;(is-big-shot (bitdiddle ben) computer)
