; This sort of exercise is really excellent to make sure readers *have to think*

;Ben Bitdiddle worries that it would be better to implement the bank account as follows (where the
;commented line has been changed):
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance
               (- balance amount))
             balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
        ((eq? m 'deposit) (protected deposit))
        ((eq? m 'balance)
          ((protected
             (lambda () balance)))) ; serialized
        (else
          (error "Unknown request: MAKE-ACCOUNT"
            m))))
    dispatch))

;because allowing unserialized access to the bank balance
;can result in anomalous behavior. Do you agree? Is there
;any scenario that demonstrates Ben’s concern?


; HMMMM.
; I think I disagree with Ben Bitdiddle.
; It's true that there might be concurrent deposit/withdraw operations running, and we can still get a balance.
; It won't reflect these operations.
; But it's fine ?
; One use case that is not solved by serializing the 'get balance' is doing something like:
; (withdraw (balance account) (/ (balance account) 2))
; because the 'get' operations might still be interleaved with withdraw/deposit (set operations) from other processes.


; Ah. Interesting line from https://eli.thegreenplace.net/2007/10/26/sicp-334:
;> Perhaps, had withdraw did two assignments to the balance, for whatever reason, we could hit an intermediate state with an access.
; Didn't think about that at all !