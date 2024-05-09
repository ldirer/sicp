
;Exercise 3.29: Another way to construct an or-gate is as
;a compound digital logic device, built from and-gates and
;inverters. Deﬁne a procedure or-gate that accomplishes
;this. What is the delay time of the or-gate in terms of and-
;gate-delay and inverter-delay?

; OR gate:
; ---a-->INVERTER--> |
;                    | AND -->INVERTER--> OUTPUT
; ---b-->INVERTER--> |
; OR(a, b) = NOT(AND(NOT(a), NOT(b)))
; verify with truth table.

(define (or-gate a b)
  (inverter (and-gate (inverter a) (inverter b)))
  )

; time delay for this or gate is inverter delay + and delay + inverter delay = 2 * inverter delay + and delay

