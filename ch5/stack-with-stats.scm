(define (make-stack)
  (let ((s '())
         (number-pushes 0)
         (max-depth 0)
         (current-depth 0)
         )

    (define (push x)
      (set! number-pushes (+ number-pushes 1))
      (set! current-depth (+ current-depth 1))
      (if (> current-depth max-depth) (set! max-depth current-depth))
      (set! s (cons x s))
      )

    (define (pop)
      (if (null? s)
        (error "Empty stack -- POP")
        (let ((top (car s)))
          (set! s (cdr s))
          (set! current-depth (- current-depth 1))
          top
          )
        )
      )

    (define (initialize)
      (set! s '())
      (set! number-pushes 0)
      (set! max-depth 0)
      (set! current-depth 0)
      'done
      )
    (define (print-statistics)
      (newline)
      (display (list 'total-pushes '= number-pushes 'maximum-depth '= max-depth))
      )

    (define (dispatch message)
      (cond
        ; similar to how we deal with set/get messages above. one returns a function.
        ; The other just does the thing. Feels like currying.
        ((eq? message 'push) push)
        ((eq? message 'pop) (pop))
        ((eq? message 'initialize) (initialize))
        ((eq? message 'print-statistics) (print-statistics))
        (else (error "Unknown request -- STACK" message))
        )
      )

    dispatch
    )
  )
