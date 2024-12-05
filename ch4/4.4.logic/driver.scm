; code from section 4.4.4.1, ~p470 paper
(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query results:")


(define (interpret exp)
  (let ((q (query-syntax-process exp)))
    (cond
      ; admittedly it's weird to do this here as if we were manipulating a query (syntax transformed too!)
      ; this is just a quick convenience addition.
      ((load? q) (load-inside-logic-interpreter (load-filename q)))
      ((assertion-to-be-added? q)
        (add-rule-or-assertion! (add-assertion-body q))
        (newline)
        (display "Assertion added to data base.")
        )
      (else
        (newline)
        (display output-prompt)
        (display-stream
          (stream-map
            (lambda
              (frame)
              (instantiate q
                frame
                (lambda (v f)
                  (contract-question-mark v))))
            (qeval q (singleton-stream '()))))
        )
      )
    )
  )

(define (query-driver-loop)
  (prompt-for-input input-prompt)
  (interpret (read))
  (query-driver-loop)
  ;
  ;  (let ((q (query-syntax-process (read))))
  ;    (cond
  ;      ((assertion-to-be-added? q)
  ;        (add-rule-or-assertion! (add-assertion-body q))
  ;        (newline)
  ;        (display "Assertion added to data base.")
  ;        (query-driver-loop))
  ;      (else
  ;        (newline)
  ;        (display output-prompt)
  ;        (display-stream
  ;          (stream-map
  ;            (lambda
  ;              (frame)
  ;              (instantiate q
  ;                frame
  ;                (lambda (v f)
  ;                  (contract-question-mark v))))
  ;            (qeval q (singleton-stream '()))))
  ;        (query-driver-loop))))
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
    (let loop ((expr (read input-port)))
      (if (eof-object? expr)
        (begin
          (close-input-port input-port)
          'done-loading-file)
        (begin
          (interpret expr)
          (loop (read input-port))))))
  )

