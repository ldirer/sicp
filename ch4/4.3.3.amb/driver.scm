(define input-prompt ";;; Amb-Eval input")
(define output-prompt ";;; Amb-Eval value")

(define (driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again)
        (try-again)
        (begin
          (newline)
          (display ";;; Starting a new problem ")
          (ambeval
            input
            the-global-environment
            ;; ambeval success
            (lambda (val next-alternative)
              (announce-output output-prompt)
              (user-print val)
              ; the fail continuation is our 'try-again' function. Damn that just fits nicely.
              (internal-loop next-alternative)
              )
            ;; ambeval failure
            (lambda ()
              (announce-output ";;; There are no more values of ")
              (user-print input)
              (driver-loop)
              )
            )
          )
        )
      )
    )

  ; initial call: the try-again procedure will complain there is no current problem and restart.
  (internal-loop
    (lambda ()
      (newline)
      (display ";;; There is no current problem")
      (driver-loop)
      )
    )
  )