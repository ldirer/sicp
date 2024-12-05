; use logic
(load "ch4/4.4.logic/data_jobs.scm")

;give simple queries that retrieve the following information from the data base:
; a. all people supervised by Ben Bitdiddle
; b. the names and jobs of all people in the accounting division
; c. the names and addresses of all people who live in Slumerville

; a.
(supervisor ?x (Bitdiddle Ben))

; results:
;(supervisor (tweakit lem e) (bitdiddle ben))
;(supervisor (fect cy d) (bitdiddle ben))
;(supervisor (hacker alyssa p) (bitdiddle ben))

; b.
(job ?person (accounting . ?title-details))
; results:
;(job (cratchet robert) (accounting scrivener))
;(job (scrooge eben) (accounting chief accountant))

; c
(address ?person (Slumerville . ?address-details))
; results:
;(address (aull dewitt) (slumerville (onion square) 5))
;(address (reasoner louis) (slumerville (pine tree road) 80))
;(address (bitdiddle ben) (slumerville (ridge road) 10))


