; use logic
(load "ch4/4.4.logic/data_jobs.scm")

; a rule that says that person 1 can replace person 2 if
; either person 1 does the same job as person 2
; or someone who does person 1's job can also do person 2's job, and if person 1 and person 2 are not the same person.

(assert! (rule (same ?a ?a)))

(assert!
  (rule (?person1 can-replace ?person2)
    (and
      (job ?person1 ?job1)
      (job ?person2 ?job2)
      (or
        (same ?job1 ?job2)
        (can-do-job ?job1 ?job2)
        )
      (not (same ?person1 ?person2))  ; this needs to be last! See what the book says about not being a filter rather than a 'proper' logical not
      )
    )
  )

;a. all people who can replace Cy D. Fect
(?person can-replace (Fect Cy D))

; results:
;((bitdiddle ben) can-replace (fect cy d))
;((hacker alyssa p) can-replace (fect cy d))

; sanity check, I had typos in my data.scm.
;((Bitdiddle Ben) can-replace (Fect Cy D))
;; results:
;;((bitdiddle ben) can-replace (fect cy d))

;b. all people who can replace someone who is being paid more than they are, together with the two salaries.
(and
  (?person1 can-replace ?person2)
  (salary ?person1 ?salary1)
  (salary ?person2 ?salary2)
  (lisp-value > ?salary2 ?salary1)
  )

; results:
;(and ((aull dewitt) can-replace (warbucks oliver)) (salary (aull dewitt) 25000) (salary (warbucks oliver) 150000) (lisp-value > 150000 25000))
;(and ((fect cy d) can-replace (hacker alyssa p)) (salary (fect cy d) 35000) (salary (hacker alyssa p) 40000) (lisp-value > 40000 35000))


;(debug)
;H
