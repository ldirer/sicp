; See book for logic
; Basically counting the ways of making change by summing
; 1. ways of making change for amount - coin 
; 2. ways of making change without using the highest coint
; (either we use the highest coin, or we don't. partition of the change 'solutions')


; make change for 10 cents using 5 cents (nickels) and 1 cents (pennies)
; 1. use 5 cents: count-change 5 cents
; 2. don't use 5 cents: count-change-without-5-cents 10 cents = 1
; 1 becomes: 
;   1.1 count-change 0 cents = 1
;   1.2 count-change-without-5-cents 5 cents = 1
; Total: 3
; confirmed by the code \o/

(define (count-change amount-in-pennies)
  (cc amount-in-pennies 5))


(define (cc amount kinds-of-coins)
  (cond 
    ((= kinds-of-coins 0) 0)
    ((= amount 0) 1)
        ((< amount 0) 0)
        ((> amount 0)   ; idk can't get it to work with else keyword
           (+ (cc (- amount (first-denomination kinds-of-coins)) kinds-of-coins) 
                   (cc amount (- kinds-of-coins 1)))
           )))

(define (first-denomination kinds-of-coins) 
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)
   ))



; This generates a tree-recursive process. Similar to fibonacci. 
; (count-change 500) takes a couple seconds to compute already

(count-change 500)
; Value: 59576



