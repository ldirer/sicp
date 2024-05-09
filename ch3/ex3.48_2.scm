;(load "ch3/3.4.2/serializer.scm")
; parallel includes a version of mutex and make-serializer
(load "ch3/3.4.2/parallel.scm")
(load "ch3/3.4.2/sleep.scm")
; > one way to avoid the deadlock is to give each account a unique identification number and rewrite serializerd-exchange
; > so that a process will always attempt to enter a procedure protecting the lowest-numbered account first.

; Previous deadlock scenario:
; P1 exchanges a1 with a2
; P2 exchanges a2 with a1
; P1 enters a serialized procedure protecting a1
; P2 enters a serialized procedure protecting a2
; Now P1 wants to enter a serialized procedure protecting a2. P2 wants to enter a serialized procedure protecting a1.
; Deadlock.

; if accounts are numbered, P1 and P2 will always enter serialized procedures in the same order: a1 then a2.
; This way they can never be waiting on each other.


(define (make-account-and-serializer balance number)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount)) balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount)) balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
        ((eq? m 'deposit) deposit)
        ((eq? m 'balance) balance)
        ((eq? m 'serializer) balance-serializer)
        ((eq? m 'number) number)
        (else (error "Unknown request: MAKE-ACCOUNT" m))))
    dispatch)
  )


(define (exchange account1 account2)
  (display "entering exchange with accounts ")
  (display (account1 'number))
  (display " and ")
  (display (account2 'number))
  (newline)
  (let ((difference (- (account1 'balance)
                      (account2 'balance))))
    (sleep 1)
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference))
  (display "DONE")
  (newline)
  )

(define (serialized-exchange-deadlocky account1 account2)
  (display "serialized-EXCHANGING account1=")
  (display (account1 'number))
  (display ", account2=")
  (display (account2 'number))
  (newline)
  (let ((serializer1 (account1 'serializer))
         (serializer2 (account2 'serializer)))
    ((serializer1 (lambda (a1 a2)
                    (sleep 1)
                    ((serializer2 exchange) a1 a2)
                    ))
      account1
      account2))
  )

; fixed version, no deadlocks. Kept the sleep so it's a fair comparison.
(define (serialized-exchange account1 account2)
  (display "serialized-EXCHANGING account1=")
  (display (account1 'number))
  (display ", account2=")
  (display (account2 'number))
  (newline)
  (if
    (> (account1 'number) (account2 'number))
    (begin
      (display "SKIPPING")
      (newline)
      (serialized-exchange-deadlocky account2 account1)
      )
    (serialized-exchange-deadlocky account1 account2)
    )
  )

(define a1 (make-account-and-serializer 0 1))
(define a2 (make-account-and-serializer 100 2))

; try with the deadlocky version, "DONE" is not printed (no matter how long we wait: we did enter a deadlock :))
(define p1 (lambda () (serialized-exchange a1 a2)))
(define p2 (lambda () (serialized-exchange a2 a1)))

(define terminator1 (parallel-execute p1 p2))
(sleep 10)
;(terminator1)
(begin
  (newline)
  (display "balance a1=")
  (display (a1 'balance))
  (newline)
  (display "balance a2=")
  (display (a2 'balance))
  (newline)
  )
