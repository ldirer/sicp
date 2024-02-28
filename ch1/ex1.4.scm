(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; nice. I'm not sure why the text says "our model of evaluation allows for combinations whose operators are compound expressions" though.
; Is this the critical thing here ? Looks to me like what's critical is that operators are values ? 
; making the ((> b 0) + -) part work as intended (which I'm assuming is the focus of the example).

