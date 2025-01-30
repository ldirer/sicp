
; > In evaluating a procedure application, the explicit-control evaluator always
; > 1. saves and restores the env register around the evaluation of the operator,
; > 2. saves and restores env around the evaluation of each operand (except the final one),
; > 3. saves and restores argl around the evaluation of each operand, and
; > 4. saves and restores proc around the evaluation of the operand sequence.

; > For each of the following combinations, say which of these save and restore operations are superfluous and thus could be eliminated by the compiler's `preserving` mechanism.


(f 'x 'y)

; I think 1. is not required because the env is not modified by a variable lookup.
; 2. 'clearly' not required
; 3. I think all argl save/restore not required
; 4. not required, no proc call inside arguments

; So none of them here.



((f) 'x 'y)
; 1. is required because evaluating '(f) means running the body of f in the procedure env.
; 2. not required
; 3. not required
; 4. not required

; 2, 3, 4: same reasoning as previous example.



(f (g 'x) y)
; Note y is a variable here
; But my answers would be the same as the next example.
; I'm probably missing something!
; aaah maybe it's that *this example* requires preserving env around operands, but **not the next one** because evaluating ''y does not use env!

(f (g 'x) 'y)
; 1. not required, same as example 1.
; 2. required for '(g 'x).
;--> Actually NOT required for this one, because evaluating ''y does not use env!
; 3. required for the first operand because '(g 'x) will modify argl.
; 4. required because '(g 'x) will modify proc.
