;2.27
;
(define (deep-reverse items)
  (define (deep-reverse-iter items result)
    (cond
      ((null? items) result)
      ((pair? (car items)) (deep-reverse-iter
                             (cdr items)
                             (deep-reverse-iter (car items) result))
        ))
    )
  (deep-reverse-iter items (list))
  )

(pair? (car (list 1)))
;expected: false

(define x (list (list 1 2) (list 3 4)))
;((1 2) (3 4))

(reverse x)
; expected: ((3 4) (1 2))
(deep-reverse x)
; expected: ((4 3) (2 1))



; Can we build an iterative version ?
; This says it's not really possible ! https://people.eecs.berkeley.edu/~bh/61a-pages/Solutions/week6
; interesting.
