;• (get-signal ⟨ wire ⟩)
;returns the current value of the signal on the wire.
;• (set-signal! ⟨ wire ⟩ ⟨ new value ⟩)
;changes the value of the signal on the wire to the new value.
;• (add-action! ⟨ wire ⟩ ⟨ procedure of no arguments⟩)
;asserts that the designated procedure should be run whenever
;the signal on the wire changes value. Such procedures are the
;vehicles by which changes in the signal value on the wire are
;communicated to other wires.

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
    (else 0)
    )
  )




; AND truth table
; a   b  output
; 0   0    0
; 1   0    0
; 0   1    0
; 1   1    1


;Exercise 3.28: Deﬁne an or-gate as a primitive function
;box. Your or-gate constructor should be similar to and-gate.

;(define logical-or or)
(define (logical-or a b)
  (cond
    ((or (= a 1) (= b 1)) 1)
    (else 0)
    )
  )

(logical-or 0 1)
;expected 1
(logical-or 0 0)
;expected 0

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



(define or-gate-delay 1)
(define and-gate-delay 1)
(define inverter-delay 2)


; skipping delay so we can test gates
(define (after-delay delay procedure)
  (procedure)
  )

(define a1 (make-wire))
(define a2 (make-wire))
(define a3 (make-wire))
(or-gate a1 a2 a3)
(set-signal! a1 1)
(set-signal! a2 0)
(get-signal a3)
;expected 1
(set-signal! a1 0)
(set-signal! a2 0)
(get-signal a3)
;expected 0


(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay inverter-delay
        (lambda () (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok
  )

(define (logical-not s)
  (cond ((= s 0) 1)
    ((= s 1) 0)
    (else (error "Invalid signal" s))))


(define (or-gate-too a b output)
  (define not-a (make-wire))
  (define not-b (make-wire))
  (define almost-there (make-wire))

  (inverter a not-a)
  (inverter b not-b)

  (and-gate not-a not-b almost-there)
  (inverter almost-there output)
  'ok
  )

; inverter = NOT
; Maud: a OR b ~ (close) ~ NOT(a AND b)
; a   b   (a OR b)  (a AND b)  (NOT a)  (NOT b) ((NOT a) AND (NOT b))  (NOT(((NOT a) AND (NOT b))))
; 0   0      0          0         1       1             1                     0
; 1   0      1          0         0       1             0                     1
; 0   1      1          0         1       0             0                     1
; 1   1      1          1         0       0             0                     1


;OR = NOT (AND (NOT(a), NOT(b)))


;----a---- INVERTER --->|
;                       | AND GATE | --almost-there--> INVERTER ---> OUTPUT
;----b---- INVERTER --->|
; expected or-delay: 2*inverter-delay + and-delay

; skipping delay so we can test gates

;(TIMELINE (list))
(define (after-delay delay procedure)
  (display "delay=")
  (display delay)
  (newline)
  (procedure)
  )


(define a1 (make-wire))
(define a2 (make-wire))
(define a3 (make-wire))
(or-gate-too a1 a2 a3)
(set-signal! a1 1)
(set-signal! a2 0)
(get-signal a3)
;expected 1
(set-signal! a1 0)
(set-signal! a2 0)
(get-signal a3)
;expected 0



; ex3.30


(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))

(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire)) (c1 (make-wire)) (c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))

;What is the delay needed to obtain the complete output from an n-bit ripple-
;carry adder, expressed in terms of the delays for and-gates,
;or-gates, and inverters?

; delay? N * Full Adder delay
; full-adder-delay: 2*half-adder-delay + or-gate-delay
; half-adder-delay: and-gate-delay + MAX(or-gate-delay, and-gate-delay + inverter-delay)

;Write a procedure ripple-carry-adder that generates this circuit.

; a-list: A1 A2 A3...
(define (ripple-carry-adder a-list b-list s-list c)
  (define n (length a-list))
  (define c-list (cons c (map (lambda item: (make-wire)) a-list)))
  (define (iter a-list b-list s-list c-list)
    (cond ((null? a-list) 'ok)
      (else
        (full-adder (car a-list) (car b-list) (cadr c-list) (car s-list) (car c-list))
        (iter (cdr a-list) (cdr b-list) (cdr s-list) (cdr c-list))
        )
      )
    )
  'ok
  )


(ripple-carry-adder (list 1 0 0 0) b-list s-list c)