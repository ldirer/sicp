; use logic
(load "ch4/4.4.logic/ex4.63.scm")


(assert!
  (rule (ends-with-grandson (?car . ?cdr))
    (ends-with-grandson ?cdr)
    )
  )
(assert!
  (rule (ends-with-grandson (grandson)))
  )

; two first queries return a result, not the third one: good.
;(ends-with-grandson (great grandson))
;(ends-with-grandson (great great grandson))
;(ends-with-grandson (great great nope))

; I'm assuming we only doing the _dudes_ here.
; if we need to go through women lineage too I think it's more complicated.
(assert!
  (rule ((great . ?rel) ?old ?young)
    (and
      (ends-with-grandson ?rel)  ; I'm not sure how to use ends-with-grandson (suggested by the exercise...)
      (son ?old ?son)
      ; note ?rel is a list here.
      (?rel ?son ?young)
      )
    )
  )
; lame fix to the fact that the great . ?rel rule will try to evaluate (grandson) instead of grandson.
(assert!
  (rule ((grandson) ?old ?young)
    (grandson ?old ?young)
    )
  )

((great grandson) Adam Irad)
; expected results:
;((great grandson) Adam Irad)

((?great grandson) ?g ?ggs)
;;;; Query results:
;((great grandson) mehujael jubal)
;((great grandson) irad lamech)
;((great grandson) mehujael jabal)
;((great grandson) enoch methushael)
;((great grandson) cain mehujael)
;((great grandson) adam irad)


; that's a cool query :). This hangs after printing a result. I guess it's because it wants to check for great great great great ... and so on.
(?relationship Adam Irad)