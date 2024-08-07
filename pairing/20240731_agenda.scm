(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
        (begin (set! signal-value new-value)
               (call-each action-procedures))
        'done))
    (define (accept-action-procedure! proc)
      (set! action-procedures
        (cons proc action-procedures))
      (proc))
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
        ((eq? m 'set-signal!) set-my-signal!)
        ((eq? m 'add-action!) accept-action-procedure!)
        (else (error "Unknown operation: WIRE" m))))
    dispatch))



(define (get-signal wire) (wire 'get-signal))
(define (set-signal! wire new-value)
  ((wire 'set-signal!) new-value))
(define (add-action! wire action-procedure)
  ((wire 'add-action!) action-procedure))


(define (call-each procedures)
  (if (null? procedures)
    'done
    (begin ((car procedures))
           (call-each (cdr procedures)))))


; a1, a2 and output are *wires*
(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
            (logical-and (get-signal a1) (get-signal a2))))
      (after-delay
        and-gate-delay
        (lambda () (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)

(define (logical-and a b)
  (cond ((and (= a 1) (= b 1)) 1)
    (else 0)))

; AND truth table
; a   b  output
; 0   0    0
; 1   0    0
; 0   1    0
; 1   1    1

; make-wire -> add-action! -> proc runs every time set-signal! is called on a
; wire.


; "segments":
; Option 1: ((t1, proc1), (t1, proc2)...)
; Option 2: (t1 (proc1 proc2) ...)




(define (make-agenda)
  (define current-time 0)
  (define segments '())
  (define max-run-steps 2000)
  (define (add-segment! time proc)
;    (if (null? segments)
;      (set! segments (list (list time proc)))
      (set! segments (cons (list time proc) segments))
      )
;    )

  (define (after-delay delay proc)
    (add-segment! (+ current-time delay) proc)
    )

  ; calls the procs in the next time segment
  (define (agenda-run-tick)
    ; lookup procedures scheduled at current time
    ; ((t proc) (t proc) ..)
    ;    (car (car segments))
    (display "segments\n")
    (display segments)
    (display "\n")
    (define segments-current-time (filter (lambda (record) (= (car record) current-time)) segments))
    (define procs-to-run (map cadr segments-current-time))

    (for-each (lambda (proc) (proc)) procs-to-run)

    (set! current-time (+ current-time 1))
    )

  ;  (define wires-to-display)
  ;  (define (add-wire wire) ...)

  ; runs to completion
  (define (agenda-run)
    (if (> current-time max-run-steps)
      (error "would run for too long, stopped at time " current-time)
      ((begin
         (agenda-run-tick)
         (agenda-run)
         )
        )
      )
    )


  (define (dispatch m)
    (cond
      ((eq? m 'after-delay) after-delay)
      ((eq? m 'run) agenda-run)
      ((eq? m 'run-tick) agenda-run-tick)
      )
    )
  dispatch
  )

(define agenda (make-agenda))
(define after-delay (agenda 'after-delay))

; (add-proc delay proc) -> adds
; (TIME, proc), ordered by time

; (agenda-run-tick) -> calls the procs in the next time segment
; (agenda-run) -> calls after-delay


;(define (after-delay delay proc) (proc))



; stuff for half adder
(define (logical-or a b)
  (cond
    ((or (= a 1) (= b 1)) 1)
    (else 0)
    )
  )
(define (logical-not s)
  (cond ((= s 0) 1)
    ((= s 1) 0)
    (else (error "Invalid signal" s))))
(define (or-gate a1 a2 output)
  (define (or-action-procedure)
    (let ((new-value
            (logical-or (get-signal a1) (get-signal a2))))
      (after-delay
        or-gate-delay
        (lambda () (set-signal! output new-value)))))
  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok)


(define inverter-delay 4)
(define and-gate-delay 3)
; expected or-delay: 2*inverter-delay + and-delay
(define or-gate-delay 5)  ; winner \o/ !!


(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay inverter-delay
        (lambda () (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok
  )

(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok)
  )

(define a (make-wire))
(define b (make-wire))
(define s (make-wire))
(define c (make-wire))


;(define (print-wire-value wire name)
;
;  )

(add-action! a (lambda () (begin
                            (display "value on wire a:\n")
                            (display (get-signal a))
                            (display "\n")
                            )
                 ))
(add-action! b (lambda () (begin
                            (display "value on wire b:\n")
                            (display (get-signal b))
                            (display "\n")
                            )
                 ))
(add-action! s (lambda () (begin
                            (display "value on wire s:\n")
                            (display (get-signal s))
                            (display "\n")
                            )
                 ))
(add-action! c (lambda () (begin
                            (display "value on wire c:\n")
                            (display (get-signal c))
                            (display "\n")
                            )
                 ))

(half-adder a b s c)

(set-signal! a 1)


(define run-tick (agenda 'run-tick))
(run-tick)
(run-tick)
(run-tick)



;(define a1 (make-wire))
;(define a2 (make-wire))
;(define a3 (make-wire))
;(and-gate a1 a2 a3)
;(set-signal! a1 1)
;(set-signal! a2 0)
;(get-signal a3)

