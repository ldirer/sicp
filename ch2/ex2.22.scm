
; First implementation produces the list in reverse order.
; Not sure what to explain.
; recursively `answer` will look like `()`, `(first-element)`, `(second-element, first-element)`, and so on.


; The second implementation doesn't work because `cons` cannot be used with a 'scalar' as second argument. 
; The second argument should be a list.
