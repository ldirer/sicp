
; exchanging=running the procedure from the book.
; exchanging money between 2 of 3 accounts A, B, and C with balances: 10, 20, 30.
; an exchange between 2 of these results in swapping their balances.

; I'm interpreting "if the processes are run sequentially" as "using serialized-exchange".

; If we use the version where the exchange isn't serialized (only deposit/withdraw operations are), then we can have:
; 1. Exchange A and B starts, reads both balances.
; 1. Computes difference: 10
; 2. Exchange B and C starts and completes.
; 2. B is now at 30, C at 20.
; 1. withdraw 10 from B: B at 20.
; 1. deposit 10 into A: A at 20.

; Now we have A, B and C all at 20.

; Exercise: On the other hand, argue that even with this `exchange` program, the sum of the balances in the accounts will be preserved.
; difference is computed. Then we withdraw it from one account, add it to another. `difference` cannot change over time once computed.
; this guarantees the total sum of balances is preserved.


; If 'withdraw or 'deposit were NOT serialized, then we are back to the situation described before considering 'exchange'.
; We might have something like:
; 1. withdraw 10 from A
; 1. withdraw 10 from A
; running concurrently and resulting in withdrawing *only* 10 from A, because (for example) both withdraw processes
; read the balance prior to any modification (say it's 30), then `set! balance 20`.
; one operation is lost, and the sum of balances across accounts is not preserved.
