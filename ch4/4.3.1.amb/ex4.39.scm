;I think reordering restrictions can lead to a faster program.
;Consider this scenario:
;
;  (require always-true)
;  (require always-true)
;  (require always-false)
;
;If we had the 'always-false' condition first, we would not test the first two.
;It is most relevant if the 'always true' conditions are expensive.
;
;At the end of the day I think there can be a speedup but a bigger win would be to limit the number of explored states.

(define (distinct? items)
  (cond ((null? items) true)
    ((null? (cdr items)) true)
    ((member (car items) (cdr items)) false)
    (else (distinct? (cdr items)))
    )
  )


(define (time-it thunk)
  (let ((start-time (runtime)))
    (let ((result (thunk)))  ; Execute the function
      (let ((end-time (runtime)))
        (display "Elapsed time: ")
        (display (- end-time start-time))
        (display " ms")
        (newline)
        result))))  ; Return the function's result


(define (multiple-dwelling-marginally-faster)
  (let
    (
      (baker (amb 1 2 3 4 5))
      (cooper (amb 1 2 3 4 5))
      (fletcher (amb 1 2 3 4 5))
      (miller (amb 1 2 3 4 5))
      (smith (amb 1 2 3 4 5))
      )
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (require (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (list
      (list 'baker baker)
      (list 'cooper cooper)
      (list 'fletcher fletcher)
      (list 'miller miller)
      (list 'smith smith)
      )
    )
  )

(define (multiple-dwelling)
  (let
    (
      (baker (amb 1 2 3 4 5))
      (cooper (amb 1 2 3 4 5))
      (fletcher (amb 1 2 3 4 5))
      (miller (amb 1 2 3 4 5))
      (smith (amb 1 2 3 4 5))
      )
    (require (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list
      (list 'baker baker)
      (list 'cooper cooper)
      (list 'fletcher fletcher)
      (list 'miller miller)
      (list 'smith smith)
      )
    )
  )

(time-it multiple-dwelling-marginally-faster)
(time-it multiple-dwelling)

(time-it multiple-dwelling)
(time-it multiple-dwelling-marginally-faster)
;; the timings (not super rigorous) seem to indicate we did gain a few ms.
;;;; Amb-Eval input:
;(time-it multiple-dwelling-marginally-faster)
;;;; Starting a new problem Elapsed time: .29 ms
;
;;;; Amb-Eval value:
;((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
;
;;;; Amb-Eval input:
;(time-it multiple-dwelling)
;;;; Starting a new problem Elapsed time: .32999999999999996 ms
;
;;;; Amb-Eval value:
;((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
;
;;;; Amb-Eval input:
;(time-it multiple-dwelling)
;;;; Starting a new problem Elapsed time: .32000000000000006 ms
;
;;;; Amb-Eval value:
;((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
;
;;;; Amb-Eval input:
;(time-it multiple-dwelling-marginally-faster)
;;;; Starting a new problem Elapsed time: .25 ms