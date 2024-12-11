; use logic
(load "ch4/4.4.logic/data_jobs.scm")

; define rules to implement the reverse operation: returns a list containing the same elements as a given list, in reverse order.
; hint: use append-to-form


(assert!
  (rule (reverse (?car . ?cdr) ?result)
    (and
      (reverse ?cdr ?rev)
      (append-to-form ?rev (?car) ?result)
      )
    )
  )
(assert!
  (rule (reverse () ()))
  )

;(append-to-form (a b) (c d) ?z)
;(append-to-form (3 2) (1) (3 2 1))
;
(reverse (1 2 3) ?x)
; this does not work: it prints the result but then hangs.
; it's not obvious why *exactly* it hangs.
; I'd say: because it's trying to (reverse ?cdr ?rev) with ?cdr bound to the cdr of ?x (=free).
; this causes the list to grow over time. It finds a valid match and prints it, but then proceeds to look for more results with ever-growing lists.
; here's a log I got during my experiments:
; valid frame for: (reverse (? 2 cdr) (? 2 rev)) instantiated frame=(reverse (?car-6 ?u-446 ?u-445 ?u-444 ?u-443 ?u-442 ?u-441 ?u-440 ?u-439 ?u-438) (?u-438 ?u-439 ?u-440 ?u-441 ?u-442 ?u-443 ?u-444 ?u-445 ?u-446 ?car-6))
;(reverse ?x (1 2 3))

;; I'm not sure how to make reverse work *both ways*.
;; I thought this might work but:
;; - it produces a bunch of duplicate results (8=2**3), which makes sense now that I look at it.
;; - it still hangs at the end. --> after this I looked more into why the thing was hanging in the first place.
;(assert! (reverse-2 () ()))
;(assert!
;  (rule (reverse-2 (?car . ?cdr) (?car2 . ?cdr2))
;    (or
;      (and
;        (reverse-2 ?cdr ?x)
;        (append-to-form ?x (?car) (?car2 . ?cdr2))
;        )
;      (and
;        (reverse-2 ?cdr2 ?x)
;        (append-to-form ?x (?car2) (?car . ?cdr))
;        )
;      )
;    )
;  )
;
;; more evidently not a good idea, infinite loop :)
;;(assert!
;;  (rule (reverse-2 (?car . ?cdr) ?result)
;;    (or
;;      (and
;;        (reverse-2 ?cdr ?x)
;;        (append-to-form ?x (?car) ?result)
;;        )
;;      (reverse-2 ?result (?car . ?cdr))
;;      )
;;    )
;;  )
;
;(reverse-2 (1 2 3 4) ?x)
;;(reverse-2 ?x (1 2 3))
