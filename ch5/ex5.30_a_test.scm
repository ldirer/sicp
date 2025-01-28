; use eceval

; unbound variable, should report an error but keep us in the (cleaned up) eceval repl
a

; user can define any variable, no conflicts with sentinel error value
(define b (cons 'unbound-variable '()))
(cons 'ok b)

; setting an undefined variable
(set! c "hello")

(define (f a b) (+ a b))

; too few/too many arguments
(f 1)

(f 1 2 3)


; we should still be in the repl
(f 1 1)
; expected: 2


; should be ok
(define d "oh")
(set! d "hello")
