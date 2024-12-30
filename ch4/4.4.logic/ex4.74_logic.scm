; use logic

;rlwrap scheme --load "ch4/4.4.logic/ex4.74_repl.scm" < ch4/4.4.logic/ex4.74_logic.scm

(assert! (value 1))
(assert! (value 5))
(assert! (value 7))
(assert! (value 2))
(assert! (value 3))
(assert! (value 4))
(and (value ?a) (lisp-value < ?a 4))

; With regular interpreter
;;;; Query input:
;(and (value ?a) (lisp-value < ?a 4))
;;;; Query results:
;lisp-value for frame: (((? a) . 4))
;lisp-value for frame: (((? a) . 3))
;(and (value 3) (lisp-value < 3 4))
;lisp-value for frame: (((? a) . 2))
;(and (value 2) (lisp-value < 2 4))
;lisp-value for frame: (((? a) . 1))
;(and (value 1) (lisp-value < 1 4))

; With Alyssa's changes:
;;;; Query input:
;(and (value ?a) (lisp-value < ?a 4))
;;;; Query results:
;Alyssa's lisp-value for frame: (((? a) . 4))
;Alyssa's lisp-value for frame: (((? a) . 3))
;(and (value 3) (lisp-value < 3 4))
;Alyssa's lisp-value for frame: (((? a) . 2))
;(and (value 2) (lisp-value < 2 4))
;Alyssa's lisp-value for frame: (((? a) . 1))
;(and (value 1) (lisp-value < 1 4))

;This is **not what I expected**.
;I expected to see something like:
;(and (value 3) (lisp-value < 3 4))
;lisp-value for frame: (((? a) . 2))
;lisp-value for frame: (((? a) . 1))
;(and (value 2) (lisp-value < 2 4))
;(and (value 1) (lisp-value < 1 4))


; where we see lisp-value prints one value early compared with output.
; well. Idk.
