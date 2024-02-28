
; (sine 12.15) should apply the procedure p to 12.15 / 3, 12.15 / 3**2, etc. 
; until the value is lower than 0.1.  
; 12.15 / 3 ** 5 = 0.05
; the procedure should be applied 5 times.

; Order of growth in space and number of steps based on `a` (calling (sine a)):
; O(log(a))
