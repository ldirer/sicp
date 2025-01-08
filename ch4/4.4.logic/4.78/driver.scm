; code from section 4.4.4.1, ~p470 paper
(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query results:")


(define (try-again? exp) (eq? exp 'try-again))

; quick hack to get print statements debugging in file loading...
(define (display? exp) (eq? (car exp) 'display))
(define (newline? exp) (eq? (car exp) 'newline))

(define (interpret exp)
;  (display "LOGIC INTERPRETING: ")
;  (display exp)
;  (newline)
  (cond
    ((try-again? exp) (amb))   ; trigger a 'try again' - needs to be first in cond because the others assume exp is a list.
    ((display? exp) (display exp))
    ((newline? exp) (newline))
    ((load? exp) (load-inside-logic-interpreter (load-filename exp)))
    ((debug? exp) (toggle-debug))
    (else
      (let ((q (query-syntax-process exp)))
        (cond
          ((assertion-to-be-added? q)
            (add-rule-or-assertion! (add-assertion-body q))
            (newline)
            (display "Assertion added to data base.")
            )
          (else
            (display output-prompt)
            (define answer-frame (qeval q '()))
            (newline)
            (display (instantiate q answer-frame (lambda (v f) (contract-question-mark v))))
            ; adding (amb) here is a way to force printing all results.
            ; then the ambevaluator needs (query-driver-loop) to start a new logic query loop.
             (amb)
            )
          )
        )
      )
    )
  )

(define (query-driver-loop)
  (prompt-for-input input-prompt)
  (interpret (read))
  (query-driver-loop)
  )

; replace any variables in the expression by their values in a given frame.
; Values might contain variables so we need a recursive call.
; used to display results.
(define (instantiate exp frame unbound-var-handler)
  (define (copy exp)
    (cond ((var? exp)
            (let ((binding (binding-in-frame exp frame)))
              (if binding
                (copy (binding-value binding))
                (unbound-var-handler exp frame))))
      ((pair? exp)
        (cons (copy (car exp)) (copy (cdr exp))))
      (else exp))
    )
  (copy exp)
  )


(define (load-inside-logic-interpreter filename)
  (let ((input-port (open-input-file filename)))
    ; tiny rewrite to avoid having to support 'let loops' inside the ambeval interpreter.
    (define (loop expr)
      (if (eof-object? expr)
        (begin
          (close-input-port input-port)
          'done-loading-file)
        (begin
          (interpret expr)
          (loop (read input-port)))))
    (loop (read input-port))
    )
  )

