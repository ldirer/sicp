
; > Ben Bitdiddle observes that the Fibonacci machine's controller sequence has
; > an extra save and an extra restore, which can be removed to make a faster machine.
; > Where are these instructions?


; In `afterfib-n-1`, we restore continue and then save continue, without using or assigning to the continue register in between.
; We also don't use the stack between these two operations - there's just one instruction: '(assign n (op -) (reg n) (const 2))'.
; This is effectively a noop, we can remove them.