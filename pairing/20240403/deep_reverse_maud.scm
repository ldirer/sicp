; with Maud
(define (deep-reverse-rec items)
  (cond
    ((null? items) (list))
    ; leaf
    ((not (pair? items)) items)
    (else (append
            (deep-reverse-rec (cdr items))
            (list (deep-reverse-rec (car items)))))
    )
  )

;+
;  fib (n - 1)
;  fib (n - 2)

(define (deep-reverse-iter-for-real items)
  (define (iter now later result)
    (display "iter define")
    (display "\n")
    (display "now=")
    (display now)
    (display ", ")
    (display "later=")
    (display later)
    (display ", ")
    (display "result=")
    (display result)
    (display "\n")
    (cond
      ((null? now) result)
      ; leaf
      ((not (pair? now)) (display "in not pair? now !?") (iter later (list) (cons now result)))
      ; if (null? (cdr now)
      ((null? (cdr now)) (iter later (list) (append result (list (deep-reverse-iter-for-real (car now)))) ))
      (else (iter
              (cdr now) ; now
              (cons (car now) later)  ; later
              result  ; result
              )
        )
      )
    )

  (iter items (list) (list))
  )


;(pair? (car (list 1)))
;expected: false

(define x (list (list 1 2) (list 3 4)))
;((1 2) (3 4))

;(reverse x)
; expected: ((3 4) (1 2))

;(deep-reverse x)
; expected: ((4 3) (2 1))

;(deep-reverse-rec x)
; expected: ((4 3) (2 1))

(define y (list x x))
y
;(deep-reverse-rec y)

(deep-reverse-iter-for-real x)
; expected: ((4 3) (2 1))


;now=((1 2) (3 4) (5 6)), later=(), result=()
;now=((3 4) (5 6)), later=((1 2)), result=()
;now=((5 6)), later=((3 4) (1 2)), result=()
; cdr now empty -> iter later (list) result=(cons (reverse (car now)) result)

;now=(5 6), later=((3 4) (1 2)), result=(()) ; ??


(deep-reverse-iter-for-real y)

(define (deep-reverse items)
  (cond
    ((null? items) (list))
    ; leaf
    ((not (pair? items)) items)
    (else (append
            (deep-reverse (cdr items))
            (list (deep-reverse (car items)))))
    )
  )
