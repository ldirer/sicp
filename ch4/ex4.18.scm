; alternative transform:
;(lambda ⟨vars⟩
;(let ((u '*unassigned*) (v '*unassigned*))
;(let ((a ⟨e1⟩) (b ⟨e2⟩))
;(set! u a)
;(set! v b))
;⟨e3⟩))

;(define (solve f y0 dt)
;  (define y (integral (delay dy) y0 dt))
;  (define dy (stream-map f y))
;  y)


; > Will the 'solve' procedure work with this transform?

; This is different from the original transform because there is an extra 'let'.
; At first sight I'm not sure why it wouldn't be equivalent.
; Oh! I see that if e2 refers to `u` it will have a different behavior.

; The solve procedure would not work with this transform, `y` would be '*unassigned when evaluated in `(stream-map f y)`.

; The original transform does not have this issue.





