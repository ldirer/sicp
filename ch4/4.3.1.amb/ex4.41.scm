; this is reaaaaaally ugly. I'm sure there is a better way.
(define (multiple-dwelling)
  (define bakers (list 2 3 4))
  (define results (map
    (lambda (baker)
        (let ((coopers (filter (lambda (x) (not (= x baker))) (list 2 3 4 5))))
          (map
            (lambda (cooper)
              (let ((fletchers (filter (lambda (x) (and
                                                     (not (or (= x baker) (= x cooper)))
                                                     (not (= (abs (- x cooper)) 1))
                                                     )
                                         )
                                 (list 2 3 4))))
                (map
                  (lambda (fletcher)
                    (let ((millers (filter (lambda (x) (and
                                                         (not (or (= x baker) (= x cooper) (= x fletcher)))
                                                         (> x cooper))
                                             )
                                     (list 1 2 3 4 5))))
                      (map
                        (lambda (miller)
                          (let ((smiths (filter (lambda (x) (and
                                                              (not (or (= x baker) (= x cooper) (= x fletcher) (= x miller)))
                                                              (not (= (abs (- x fletcher)) 1))
                                                              )
                                                  )
                                          (list 1 2 3 4 5))))
                            (map
                              (lambda (smith)
                                (list
                                  (list 'baker baker)
                                  (list 'cooper cooper)
                                  (list 'fletcher fletcher)
                                  (list 'miller miller)
                                  (list 'smith smith)
                                  )
                                )
                              smiths
                              )
                            )
                          )
                        millers
                        )
                      )
                    )
                  fletchers
                  )
                )
              )
            coopers)
          )
        )
    bakers))
;    nested maps produce lists with empty lists...
; we look for an item at depth 5 with non-empty elements
;  (caaaar results)
  (car (caaaar (deep-filter-empty results)))
  )


; source: ChatGPT
(define (deep-filter-empty lst)
  (cond
    ((null? lst) '())  ; If the list is empty, return an empty list
    ((and (list? lst) (every null? lst)) '())  ; If all elements in this list are empty, return empty
    ((list? (car lst)) ; If the first element is a list, recursively filter it
     (let ((filtered-car (deep-filter-empty (car lst)))
           (filtered-cdr (deep-filter-empty (cdr lst))))
       (if (null? filtered-car)
           filtered-cdr
           (cons filtered-car filtered-cdr))))
    (else (cons (car lst) (deep-filter-empty (cdr lst))))))


(define (range a b)
  (if (> a b)
    (list)
    (cons a (range (+ a 1) b))
    )
  )

(define (time-it thunk N)
  (let ((start-time (runtime)))
    (let ((result (thunk)))  ; Execute the function
      (map (lambda (x) (thunk)) (range 1 N))
      (thunk)
      (let ((end-time (runtime)))
        (display "Elapsed time: ")
        (display (- end-time start-time))
        (display " ms (")
        (display N)
        (display " iterations)")
        (newline)
        result))))  ; Return the function's result

(time-it multiple-dwelling 100)
;(time-it multiple-dwelling 100)Elapsed time: .01 ms (100 iterations)
;;Value: ((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))

