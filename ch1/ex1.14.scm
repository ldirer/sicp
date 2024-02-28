
; count-change tree to make change for 11 cents
; cc 11 5
; cc 11 4  cc -39 5 ; negative amount => count 0 
; cc 11 3  cc -14 4 
; cc 11 2                 cc 1 3
; cc 11 1 cc 6 2            cc 1 2 cc -9 2
; 1 cc 6 1 cc 1 2               cc 1 1 cc -4 2

; 1 1 1 1 = 4?

; --> Yes, (count-change 11) returns 4


; order of growth of the space and number of steps used by this process as the amount to be 
; changed increases ?
; Not an easy question !
; the order of growth in space is O(amount).
; Because the longest branch in the call tree will be the one where we use only the smallest coin to make change.  
; I guess that's unless we got some special logic to shortcut that ?


; Number of steps complexity is NOT obvious. Needs pen and paper, see https://sicp-solutions.net/post/sicp-solution-exercise-1-14/



