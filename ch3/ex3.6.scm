; using the fictitious 'rand-update' from the book
(define random-init 10)
(define rand (let ((x random-init))
               (lambda (symbol)
                 (cond
                   ((eq? symbol 'generate)
                     (set! x (rand-update x))
                     x
                     )
                   ((eq? symbol 'reset) (set! x random-init))
                   (else (error "unknown command " symbol))
                   )
                 )
               )
  )

; stub implementation so we can test this
(define (rand-update v) (+ v 1))

(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'reset)
(rand 'generate)
