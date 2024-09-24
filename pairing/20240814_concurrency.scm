(define (make-mutex)
  (let ((cell (list false)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
              (if (test-and-set! cell)
                (the-mutex 'acquire))) ; retry
        ((eq? m 'release) (clear! cell))))
    the-mutex))
(define (clear! cell) (set-car! cell false))


; assuming this is atomic
(define (test-and-set! cell)
      (if (car cell)
        true
        (begin (set-car! cell true)
               false))
  )


; P1
; inside (test-and-set! cell):
; (if (car cell)
; (car cell) evaluates to false

; P2
; inside (test-and-set! cell):
; (if (car cell)
; (car cell) evaluates to false
