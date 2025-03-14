(load "testing.scm")

(define (make-account balance password)

  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))

  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)

  (define (dispatch pw m)
    (if (not (eq? pw password))
      (error "Incorrect password")
      )

    (cond ((eq? m 'withdraw) withdraw)
      ((eq? m 'deposit) deposit)
      (else (error "Unknown request: MAKE-ACCOUNT"
              m))))
  dispatch)

(define acc (make-account 100 'secret-password))


((acc 'secret-password 'withdraw) 40)
;expected: 60

((acc 'some-other-password 'deposit) 50)
;expected: "Incorrect password"

((acc 'secret-password 'withdraw) 10)
;expected: 50
