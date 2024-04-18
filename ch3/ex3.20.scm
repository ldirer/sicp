(define (cons x y)
  (define (set-x! v) (set! x v))
  (define (set-y! v) (set! y v))
  (define (dispatch m)
    (cond ((eq? m 'car) x)
      ((eq? m 'cdr) y)
      ((eq? m 'set-car!) set-x!)
      ((eq? m 'set-cdr!) set-y!)
      (else
        (error "Undefined operation: CONS" m))))
  dispatch
  )
(define (car z) (z 'car))
(define (cdr z) (z 'cdr))
(define (set-car! z new-value)
  ((z 'set-car!) new-value)
  z)

(define (set-cdr! z new-value)
  ((z 'set-cdr!) new-value)
  z)



; Q: Draw the environment diagrams to illustrate the sequence of expressions below.


; Global env: x=procedure cons pointing to E1, z=procedure pointing to E2
; E1: x=1 y=2, set-x! pointing to E1, set-y! pointing to E1, dispatch pointing to E1
; E2: x=x (from global env) y=x, set-x! pointing to E2, set-y! pointing to E2, dispatch pointing to E2

; skipped (cdr z) but it also creates environments.
; call to set-car! creates
; E3: z=(cdr z), new-value=17, E3 points to global env.
; (z 'set-car!) creates
; E4: m='set-car!, E4 points to **E1** ((cdr z) is a procedure pointing to E1 = x-dispatch).
; the return value is set into E3 (new binding)
; ((z 'set-car!) new-value) creates:
; E5: v=new-value, points to E2. **Sets x to new-value inside E1.**
; (car x)
; E6: z=x
; (z 'car) is a procedure (dispatch) pointing to E1
; E7: m='car. E7 points to E1. returns x from E1 (now 17).

; Clearly the list above is a bit approximate.
; It's also a bit more subtle than it looks to actually get right.


; sequence of expressions (for exercise):
(define x (cons 1 2))
(define z (cons x x))
(set-car! (cdr z) 17)
(car x)
17
(car (cdr z))
