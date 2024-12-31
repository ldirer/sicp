; use logic
(load "ch4/4.4.logic/data_jobs.scm")

;(job ?x (computer wizard))

(unique (job ?x (computer wizard)))
; expect 1 result: (unique (job (Bitdiddle Ben) (computer wizard)))

(unique (job ?x (computer programmer)))
; expect empty stream

; should list all the jobs that are ﬁlled by only one person
(and (job ?x ?j) (unique (job ?anyone ?j)))


; > Test your implementation by forming a query that lists all people who supervise precisely one person.
;; sanity check
;(unique (supervisor ?p (Hacker Alyssa P)))
;;;;; Query results:
;;;(unique (supervisor (reasoner louis) (hacker alyssa p)))


(unique (supervisor ?p (Hacker Alyssa P)))

(supervisor ?x ?boss)
(and
  (supervisor ?x ?boss)
  (unique (supervisor ?p ?boss))
  )
