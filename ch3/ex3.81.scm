(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")
(load "ch3/ex3.79.scm")
; n-ary stream-map
(load "ch3/ex3.50.scm")

(define random-init 10)
; stub implementation so we can test this
(define (rand-update v) (+ v 1))


; version from the book without reset:
;(define random-numbers (cons-stream random-init (stream-map rand-update random-numbers)))

(define (random-numbers requests)
  (define rands
    (cons-stream
      random-init
      (stream-map
        (lambda (random-next request)
          (cond
            ((eq? request 'generate) random-next)
            ((eq? request 'reset) random-init)
            (else (error "unexpected request " request))
            )
          )
        (stream-map rand-update rands)
        requests)
      )
    )
  rands
  )

; the above isn't fantastic because we do generate a random number even if we end up not using it (reset)
; we could do it explicitly (check (stream-car request), return init or (rand-update (stream-car rands))
; Turns out it's a simple fix
(define (random-numbers-2 requests)
  (define rands
    (cons-stream
      random-init
      (stream-map
        (lambda (prev request)
          (cond
            ((eq? request 'generate) (rand-update prev))
            ((eq? request 'reset) random-init)
            (else (error "unexpected request " request))
            )
          )
        rands
        requests)
      )
    )
  rands
  )

(define requests (stream-from-list (list 'generate 'generate 'generate 'reset 'generate 'generate)))

(display-stream-inline requests)
; this ends with an error because stream-map doesn't check for stream-null on all arguments. It's fine.
(display-stream-inline (random-numbers requests))
(display-stream-inline (random-numbers-2 requests))
