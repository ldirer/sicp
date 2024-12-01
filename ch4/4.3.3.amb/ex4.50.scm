(define (ramb? exp) (tagged-list? exp 'ramb))
(define (ramb-choices exp) (cdr exp))

(define (analyze-ramb exp)
  (let ((cprocs (map analyze (ramb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
          (fail)
          (let ((draw (random-item choices)))
            ((draw-pick draw)
              env
              succeed
              (lambda ()
                (try-next (draw-rest draw))
                ))
            )
          )
        )
        ; Shuffling cprocs here would be a better design (same behavior, more efficient, easier to understand)
        ; we could even move it out to the analyzing phase as done here: https://eli.thegreenplace.net/2008/01/11/sicp-section-433#fn1
        ; Doing so means the order across multiple invocations will always be the same. I don't know if that's desirable/undesirable/whatever.
      (try-next cprocs)
      )
    )
  )


; return a list with (randomed-item rest)
; it's a little stupid I think I should just shuffle the list beforehand.
; then wouldn't need to change much in the original amb code... oh well.
(define (random-item items)
  (let ((n (random (length items))))
    (cons (nth n items) (remove-nth n items))
    )
  )
(define (draw-pick draw) (car draw))
(define (draw-rest draw) (cdr draw))

(define (remove-nth n items)
  (if (= n 0)
    (cdr items)
    (cons (car items) (remove-nth (- n 1) (cdr items)))
    )
  )

(define (nth n items)
  (cond
    ((= n 0) (car items))
    (else (nth (- n 1) (cdr items)))
    )
  )
