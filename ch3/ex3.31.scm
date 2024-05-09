; accept-action-procedure! runs the procedure right after adding it to the list of actions.
; this is necessary because the code only runs actions when the value on the wire changes.
; So if some input wire doesn't change, we might be stuck with the original output value too, ignoring actions set by the gate in between.
; We would lose the propagation of **initial values**.

; In the half-adder example from the book:
; After we set the signal in input-1 to 1,
; the OR gate output would change from 0 to 1: fine.
; the AND gate output would be 0. No change: the inverter actions would not be triggered, output (E on figure 3.25)
; would have a signal of 0.
; S would be 0 at time 8 (instead of 1).

