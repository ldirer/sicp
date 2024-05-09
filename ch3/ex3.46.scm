(define (make-mutex)
  (let ((cell (list false)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
              (if (test-and-set! cell)
                (the-mutex 'acquire)))  ; retry
        ((eq? m 'release) (clear! cell))))
    the-mutex)
  )

(define (clear! cell) (set-car! cell false))
(define (test-and-set! cell)
  (if (car cell)
    true
    (begin
      (set-car! cell true)
      false
      )
    )
  )


; the above implementation does not make the 'test-and-set!' operation atomic.
; this means the mutex can fail, for instance with processes 1 and 2:
; 1. reads (car cell), sees it's false.
; 2. reads (car cell), sees it's false.
; 1. proceeds to (set-car! cell true) and acquire the mutex.
; 2. proceeds to (set-car! cell true) and acquire the mutex.
; Now they both have the mutex. Oh no!

