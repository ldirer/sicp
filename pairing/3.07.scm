(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch p m)
    (cond
      ((not (eq? p password)) (error "Incorrect password -- " p))
      ((eq? m 'withdraw) withdraw)
      ((eq? m 'deposit) deposit)
      (else (error "Unknown request -- MAKE-ACCOUNT"
              m))))
  dispatch)

;Testing
(define acc (make-account 100 'secret-password))
((acc 'secret-password 'withdraw) 40) ; Expected: 60

(define (make-joint original-account original-account-password joint-account-password)
  (define (check-password password)
    (if (and
          (not (eq? password original-account-password))
          (not (eq? password joint-account-password))
          )
      (error "Unauthorized: none of the two possible passwords -- " password)
      'ok
      )
    )
  (lambda (password action)
    (check-password password)
    (original-account original-account-password action)
    )
  )

;Testing
(define peter-acc (make-account 100 'peter-password))
(define paul-acc (make-joint peter-acc 'peter-password 'paul-password))
;((paul-acc 'wrong-paul-password 'withdraw) 60); Expected error: Unauthorized: Incorrect password -- wrong-paul-password

((paul-acc 'paul-password 'withdraw) 60) ; Expected: 40
((paul-acc 'paul-password 'deposit) 100) ; Expected: 140
((peter-acc 'peter-password 'deposit) 10) ; Expected: 150

; Extra: Allow either passwords to work for withdrawals and deposits
((paul-acc 'peter-password 'deposit) 100) ; Expected: 250


; OPTION 2 - dispatch responsibilities for password and action in 2 lambdas
(define (make-joint-2 original-account original-account-password joint-account-password)
  (define (check-password password)
    (if (and
          (not (eq? password original-account-password))
          (not (eq? password joint-account-password))
          )
      (error "Unauthorized: none of the two possible passwords -- " password)
      'ok
      )
    )
  (lambda (password)
    (check-password password)
    (lambda (action)
      (original-account original-account-password action)
      ))
  )

;Testing
(define paul-acc-2 (make-joint-2 peter-acc 'peter-password 'paul-password))
(define paul-acc-authorized (paul-acc-2 'paul-password))
((paul-acc-authorized 'withdraw) 60) ; Expected: 190
