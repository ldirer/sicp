; How many sets of assignments are there from people to floors, both before and after the requirmeent that floor assignments be distinct?
; Before: 5 ** 5 = 3125
; After: 5! = 120

(define (filter fn items)
  (cond
    ((null? items) '())
    ((fn (car items)) (cons (car items) (filter fn (cdr items))))
    (else (filter fn (cdr items)))
    )
  )

(define (amb-list items)
  (cond
    ((null? items) (amb))
    (else (amb (car items) (amb-list (cdr items))))
    )
  )

;(filter (lambda (x) (< x 3)) (list 1 2 3 4 5 6 2))
;expected: (1 2 2)

(define (multiple-dwelling)
  (let (
         (baker (amb 2 3 4))
         )
    (let (
           (cooper (amb-list (filter (lambda (x) (not (= x baker))) (list 2 3 4 5))))
           )
      (let
        ((fletcher (amb-list (filter (lambda (x) (and
                                              (not (or (= x baker) (= x cooper)))
                                              (not (= (abs (- x cooper)) 1))
                                              )
                                  )
                          (list 2 3 4)))))
        (let
          ((miller (amb-list (filter (lambda (x) (and
                                              (not (or (= x baker) (= x cooper) (= x fletcher)))
                                              (> x cooper))
                                  )
                          (list 1 2 3 4 5)))))
          (let
            ((smith (amb-list (filter (lambda (x) (and
                                               (not (or (= x baker) (= x cooper) (= x fletcher) (= x miller)))
                                               (not (= (abs (- x fletcher)) 1))
                                               )
                                   )
                           (list 1 2 3 4 5)))))
            (list
              (list 'baker baker)
              (list 'cooper cooper)
              (list 'fletcher fletcher)
              (list 'miller miller)
              (list 'smith smith)
              )
            )
          )
        )
      )
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


(time-it multiple-dwelling)
; This is **a lot** faster. 0.01ms vs 0.3ms for the original version.
;(time-it multiple-dwelling)
;;;; Starting a new problem Elapsed time: 9.999999999999995e-3 ms
;
;;;; Amb-Eval value:
;((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))

(define (test-1)
  (define baker (amb 1 2))
  baker
  )

(define (test-2)
  (let ((baker (amb 1 2)))
    baker
    )
  )

(define (test-3)
  (amb (list 1 2))
  )
(test-1)
(test-2)
(test-3)

; I had errors about 'amb' not being defined...
; The session was in an error state: we revert to regular scheme, and if we send the whole file we'll send some commands.