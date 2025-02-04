(load "ch5/compiler/compiler.scm")
(load "ch5/compiler/utils.scm")
(load "testing.scm")

;todo check why we don't need to preserve env here. Eli does not have it


;(compile '(f 1 2) 'val 'next)
;(spread-arguments '(1 2))
;
;; error too many operands
;;(spread-arguments '(1 2 3 4))
;
;(compile '(+ 1 2) 'val 'next)
;(display-list (statements (compile '(+ 1 2) 'val 'next)))
;;(assign arg1 (const 1))
;;(assign arg2 (const 2))
;;(assign val (op +) (reg arg1) (reg arg2))
;
;(display-list (statements (compile '(+ 2 (+ 1 1)) 'val 'next)))
;
;(preserving '(arg1 arg2) '(() (arg1 arg2) ((assign arg1 (const 1)) (assign arg2 (const 2))))
;  '(() (val arg1 arg2)  ((assign arg1 (const 1)) (assign arg2 (const 2)) (assign val (op +) (reg arg1) (reg arg2))))
;  )

; TODO won't work with a plain list returned by spread-arguments
;(display-list (statements (spread-arguments '(1 (+ 2 3)))))

(check-equal "save and restore correctly inserted" (statements (compile '(+ 2 (+ 1 1)) 'val 'next))
  '(
     (assign arg1 (const 2))
     (save arg1)
     (assign arg1 (const 1))
     (assign arg2 (const 1))
     (assign arg2 (op +) (reg arg1) (reg arg2))
     (restore arg1)
     (assign val (op +) (reg arg1) (reg arg2))
     )
  )
