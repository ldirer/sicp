; tried to do this with Chat. It's not working.
;https://chatgpt.com/c/67508c6b-2ce4-8006-a7e1-a4ae764895a2
; I wanted the output of (debug) H, I guess I'll just add that at the end of my files when they crash?
; Adding this:
;(debug)
;H
; does the trick but then any line after that causes *havoc*. Even commented code, since the debugger does not consider '; xxx' as comments.
;https://groups.csail.mit.edu/mac/ftpdir/scheme-7.4/doc-html/scheme_17.html

(define (print-stack-trace condition output)
  (write-condition-report condition output)
;  (let loop ((stack (stack-trace condition output)))
;    (unless (null? stack)
;      (display "ok")
;;      (write (car stack))
;      (newline)
;      (loop (cdr stack))))
  )

(define (custom-error-handler condition)
  (display "An error occurred:\n")
  (write-condition-report condition (current-output-port))
  (newline)
  (display "Stack trace:\n")
  (print-stack-trace condition (current-output-port))
  (exit 1)) ;; Exit after printing the stack trace.

(bind-condition-handler
  '()
  (lambda (condition)
    (custom-error-handler condition))
  (lambda ()
    ;; Your program starts here
    (define (example-function)
      (error "This is a test error"))

    (example-function)
    )
  )
