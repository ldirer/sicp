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



(define (call-each procedures)
  (if (null? procedures)
    'done
    (begin ((car procedures))
           (call-each (cdr procedures)))))


(define (get-signal wire) (wire 'get-signal))
(define (set-signal! wire new-value)
  ((wire 'set-signal!) new-value))
(define (add-action! wire action-procedure)
  ((wire 'add-action!) action-procedure))

(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time the-agenda))
    action
    the-agenda))


(define (propagate)
  (if (empty-agenda? the-agenda)
    'done
    (let ((first-item (first-agenda-item the-agenda)))
      (first-item)
      (remove-first-agenda-item! the-agenda)
      (propagate))))

(define (probe name wire)
  (add-action! wire
    (lambda ()
      (newline)
      (display name) (display " ")
      (display (current-time the-agenda))
      (display "
New-value = ")
      (display (get-signal wire)))))

(define the-agenda (make-agenda))
(define inverter-delay 2)
(define and-gate-delay 3)
(define or-gate-delay 5)


(define input-1 (make-wire))
(define input-2 (make-wire))
(define sum (make-wire))
(define carry (make-wire))

(probe 'sum sum)
(probe 'carry carry)

(half-adder input-1 input-2 sum carry)
(set-signal! input-1 1)
(propagate)
(set-signal! input-2 1)
(propagate)


;;agenda
;(define (make-time-segment time queue)
;  (cons time queue))
;
;(define (segment-time s) (car s))
;(define (segment-queue s) (cdr s))
;
;(define (make-agenda) (list 0))
;(define (current-time agenda) (car agenda))
;(define (set-current-time! agenda time)
;(set-car! agenda time))
;(define (segments agenda) (cdr agenda))
;(define (set-segments! agenda segments)
;(set-cdr! agenda segments))
;(define (first-segment agenda) (car (segments agenda)))
;(define (rest-segments agenda) (cdr (segments agenda)))
;
;(define (empty-agenda? agenda)
;(null? (segments agenda)))
;




; july with Jeff

; agenda: goal is to see the evolution of the circuit over time
; after-delay will be tied closely to the agenda.
; agenda does not have to care about wires, only procedures to execute at a given time.
;
; list of pairs: time, functions to run at that time


(define (after-delay delay proc) )
