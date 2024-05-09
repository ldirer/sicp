; Such a well-thought design for this event-driven simulation program, but no coding exercises.


; The agenda uses a FIFO structure for the actions.

; Let's imagine an AND gate inputs change from 1,0 to 0,1 in the same time segment.
; two possible routes:

; Option 1:
; inputs are 1,0
; inputs are 0,0
; AND gate actions run -> they schedule a change on the output wire signal. **That change is irrelevant**.
; inputs are 0,1
; AND gate actions run -> they schedule a change on the output wire signal. This one is relevant.

; Option 2:
; inputs are 1,0
; inputs are 1,1
; AND gate actions run -> they schedule a change on the output wire signal. **That change is irrelevant**.
; inputs are 0,1
; AND gate actions run -> they schedule a change on the output wire signal. This one is relevant.


;If the scheduled changes run LIFO, the relevant change will be overwritten by the irrelevant one.
