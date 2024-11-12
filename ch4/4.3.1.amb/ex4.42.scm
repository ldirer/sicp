; meant to run with the ambiguous eval interpreter
(define (xor a b)
  (if a (not b) b)
  )

(define (distinct? items)
  (cond ((null? items) true)
    ((null? (cdr items)) true)
    ((member (car items) (cdr items)) false)
    (else (distinct? (cdr items)))
    )
  )

(define (liars)

  (define betty (amb 1 2 3 4 5))
  (define ethel (amb 1 2 3 4 5))
  (define joan (amb 1 2 3 4 5))
  (define kitty (amb 1 2 3 4 5))
  (define mary (amb 1 2 3 4 5))

  (require (distinct? (list betty ethel joan kitty mary)))

  ; Kitty was second, I was only third
  (require (xor (= kitty 2) (= betty 3)))
  ; I was on top, Joan was second
  (require (xor (= ethel 1) (= joan 2)))
  ; I was third, ethel was bottom
  (require (xor (= ethel 5) (= joan 3)))
  ; I came out second, Mary fourth
  (require (xor (= kitty 2) (= mary 4)))
  ; I was fourth, top was Betty
  (require (xor (= mary 4) (= betty 1)))

  (list
    (list 'betty betty)
    (list 'ethel ethel)
    (list 'joan joan)
    (list 'kitty kitty)
    (list 'mary mary)
    )
  )

(liars)
; ((betty 3) (ethel 5) (joan 2) (kitty 1) (mary 4))

