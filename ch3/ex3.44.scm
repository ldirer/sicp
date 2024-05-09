
(define (transfer from-account to-account amount)
  ((from-account 'withdraw) amount)
  ((to-account 'deposit) amount)
  )


; assuming accounts have more than 'amount' balance
; assuming withdraw and deposit are serialized
; then there is no issue (Louis Reasoner is wrong).
; The essential difference with the previous program considered in the text is that it *reads the balance*, then use that value later.
; This opens the program to bugs where the balance changes after it's been read (from a concurrent process execution).
; Kind of like 'time of check vs time of use' issues.