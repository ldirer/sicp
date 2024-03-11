(fold-right / 1 (list 1 2 3))
; 3/2

(fold-left / 1 (list 1 2 3))
; 1/6

(fold-right list (list) (list 1 2 3))
; (1 (2 (3 ())))
(fold-left list (list) (list 1 2 3))
; (((() 1) 2) 3)

; "Give a property that `op` should satisfy to guarantee that fold-right and fold-left will produce the same values
; for any sequence."
; `op` needs to be commutative (op x y) = (op y x) for all x, y.
; This says 'associative' is the property we want https://eli.thegreenplace.net/2007/08/22/sicp-sections-223
; I don't think it's enough ?
; take a (list x y) object.
; fold-right op identity-for-op (list x y) will be (op y x)
; --> INCORRECT. It's `(op x y)`. Because of the order of arguments passed to `op`.
; fold-left op identity-for-op (list x y) will be (op x y)
; associativity is not sufficient in this case ?

; SIMPLEST CASE: consider a list with a single item.
; What about operations that are commutative but not associative ?

; commutative but not associative
; another one is the 'middle point'. Maybe easier to visualize because the result of the operation is
; 'in the same space' as the initial items.
(define (distance x y) (abs (- x y)))

(fold-left distance 0 (list 1 2 3))
(fold-right distance 0 (list 1 2 3))

; commutative but not associative
(define (nand x y) (if (not (and (= x 1) (= y 1))) 1 0))

(fold-left nand 0 (list 1 1))
(fold-right nand 0 (list 1 1))


; associative but not commutative

; TLDR: need associativity AND an initial value that commutes with the result !
; Identity works always, the rest not in general unless `op` is also commutative.
