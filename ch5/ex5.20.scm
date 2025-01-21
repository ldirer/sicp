
; > Draw the box and poitner represetnation and the memory vector representation of the list structure produced by:
(define x (cons 1 2))
(define y (list x x))


; x:
;
; starting 'the-c(a|d)rs' indexing at 4 so there's less confusion about indexes vs values on the schemas.
; An index is attached to a pair (not an arrow).
; [ |-]--> 2
; 4|
;  v
;  1


; [0 1 2 3 4 ]
; [- - - - n1]
; [- - - - n2]


; Now y...
; [ |-]-->[ |/]
; 5|      6|
;  v       v
;  x       x

; [0 1 2 3 4   5   6 ]
; [- - - - n1  p4  p4]
; [- - - - n2  p6  e0]


; ... with the free pointer initially p1.
; Woops:

; x:
; [ |-]--> 2
; 1|
;  v
;  1

; [ |-]-->[ |/]
; 2|      3|
;  v       v
;  x       x

; [1  2   3 ]
; [n1 p1  p1]
; [n2 p3  e0]

; The values of x and y are represented by pointers p1 and p2.
; The final value of free is 4.
