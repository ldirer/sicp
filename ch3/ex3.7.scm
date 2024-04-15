(load "testing.scm")
; interesting exercise ! More subtle than it looks at first glance.
; see bottom of file for a clever solution from https://eli.thegreenplace.net/2007/09/27/sicp-sections-312-313

(define (make-account balance password)

  (define (make-inner password)
    (define (withdraw amount)
      (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))

    (define (deposit amount)
      (set! balance (+ balance amount))
      balance)

    (define (make-joint new-password)
      (make-inner new-password)
      )

    (define (dispatch pw m)
      (if (not (eq? pw password))
        (error "Incorrect password")
        )

      (cond ((eq? m 'withdraw) withdraw)
        ((eq? m 'deposit) deposit)
        ((eq? m 'make-joint) make-joint)
        (else (error "Unknown request: MAKE-ACCOUNT"
                m))))
     dispatch
    )

  (make-inner password)
  )


; create an additional access to the original account
(define (make-joint account password new-password)
  ((account password 'make-joint) new-password)
)

(define acc (make-account 100 'secret-password))

(define joint (make-joint acc 'secret-password 'other-password))

((joint 'other-password 'withdraw) 10)
;expected: 90
((acc 'secret-password 'withdraw) 10)
;expected: 80

; check that passwords can't be used on any account
((acc 'other-password 'withdraw) 10)
;expected: error
((joint 'secret-password 'withdraw) 10)
;expected: error



; Eli's solution from https://eli.thegreenplace.net/2007/09/27/sicp-sections-312-313
; Clever because it does not require modifying the existing code *at all* !
; One difference in behavior is that this will always succeed (even if 'acc-pass' is not correct), and only fail when
; we try to use the returned value. Also if the password changes it breaks joint accounts.
; Still a very interesting solution ! It shows the solution above could be much nicer.
; have a `dispatch_` inner function that doesn't check password.
; and then return `(protect-with-password dispatch password)`.
; the joint constructor can return `(protect-with-password dispatch other-password)`.
(define (make-joint acc acc-pass new-pass)
  (define (proxy-dispatch password m)
    (if (eq? password new-pass)
      (acc acc-pass m)
      (error "Bad joint password -- " password)))
  proxy-dispatch)
