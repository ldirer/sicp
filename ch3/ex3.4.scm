(load "testing.scm")

(define (make-account balance password)

  (define wrong-password-count 0)
  (define wrong-password-max-allowed 3)
  (define (call-the-police)
    (display "that's it I'm calling the police")
    (display "\n")
  )

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
      (begin
        (set! wrong-password-count (+ wrong-password-count 1))
        (if (>= wrong-password-count wrong-password-max-allowed)
          (begin (call-the-police) (error "police called"))
          (error "Incorrect password, attempts remaining " (- wrong-password-max-allowed wrong-password-count))
          )
        )
      (set! wrong-password-count 0)
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
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)

((acc 'secret-password 'deposit) 50)
; the successful call should reset the 'wrong password' count.
((acc 'some-other-password 'deposit) 50)
