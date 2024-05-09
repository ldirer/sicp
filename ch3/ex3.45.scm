;Louis Reasoner thinks our bank-account sys-
;tem is unnecessarily complex and error-prone now that de-
;posits and withdrawals aren’t automatically serialized. He
;suggests that make-account-and-serializer should have
;exported the serializer (for use by such procedures as serialized-
;exchange) in addition to (rather than instead o) using it
;to serialize accounts and deposits as make-account did. He
;proposes to redeﬁne accounts as follows:
(define (make-account-and-serializer-wrong balance)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount)) balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount)) balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (balance-serializer withdraw))
        ((eq? m 'deposit) (balance-serializer deposit))
        ((eq? m 'balance) balance)
        ((eq? m 'serializer) balance-serializer)
        (else (error "Unknown request: MAKE-ACCOUNT" m))))
    dispatch)
  )

;Explain what is wrong with Louis’s reasoning. In particu-
;lar, consider what happens when serialized-exchange is
;called.

; -> It seems very reasonable at first glance, as it makes the api less error-prone for simple operations.
; however looking at serialized exchange:

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                      (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
         (serializer2 (account2 'serializer)))
    ((serializer1 (serializer2 exchange))
      account1
      account2)))

; we can see we will run into an issue:
; serializer2 and serializer1 are already wrapping exchange. Then we try to make a withdraw in exchange. If this is also using serializer1/2, it might block the call.
; --> I feel like this could be solved for tho? Like maybe we could know that the thing that we want to execute is within the scope of the thing that took the lock.

; This doesn't say anything different: https://eli.thegreenplace.net/2007/10/26/sicp-334






