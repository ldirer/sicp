(load "ch4/ex4.16.scm")
; before transformation
;(lambda ⟨vars⟩
;(define u ⟨e1⟩)
;(define v ⟨e2⟩)
;⟨e3⟩)


; after transformation
;(lambda ⟨vars⟩
;(let ((u '*unassigned*)
;(v '*unassigned*))
;(set! u ⟨e1⟩)
;(set! v ⟨e2⟩)
;⟨e3⟩))

; environments:

; before transformation:
; - global
; - attached to lambda: E1: parent=global, vars, u, v

; after transformation
; - global
; - attached to lambda: E1: parent=global, vars
; - attached to the let lambda (let once expanded): E2: parent=E1, u, v

; As the book mentions, there is one more frame in the transformed version.
; this cannot make a difference in behavior because no code is executed in E1.
; It's all in E2 (the let clause wraps the entire body).

; We can get rid of the extra frame with a different implementation though.
; We can transform into:


;(lambda ⟨vars⟩
;(define u '*unassigned*)
;(define v '*unassigned*)
;(set! u ⟨e1⟩)
;(set! v ⟨e2⟩)
;⟨e3⟩)


; it might make sense to make this function ignore (define x '*unassigned*).
; that would make it idempotent which seems like a nice property to have here.
(define (scan-out-defines body)
  (define definitions (filter definition? body))
  (define non-definitions (filter (lambda (expr) (not (definition? expr))) body))

  (define defines (map (lambda (def) (make-definition (definition-variable def) '*unassigned*)) definitions))
  (define assignments (map (lambda (def) (make-assignment (definition-variable def) (definition-value def))) definitions))

  (append defines assignments non-definitions)
  )


(define test-code
  '(
     (define u 1)
     (define v 2)
     (+ u v)
     )
  )

(scan-out-defines test-code)
;Value: ((define u *unassigned*) (define v *unassigned*) (set! u 1) (set! v 2) (+ u v))

