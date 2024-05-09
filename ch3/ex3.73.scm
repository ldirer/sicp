(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")

(define (integral integrand initial dt)

  (define int
    (cons-stream
      initial
      (add-streams
        (scale-stream integrand dt)
        int))
    )

  int
  )

(define (RC r c dt)
  (define (get-vstream istream v0)
      (add-streams
        (scale-stream istream r)
        (scale-stream (integral istream v0 dt) (/ 1 c))
      )
    )
  get-vstream
  )

(define RC1 (RC 5 1 0.5))


(display-stream (until (RC1 ones 0) 20))
;5
;5.5
;6.
;6.5
;7.
;7.5
;8.
;8.5
;9.
;9.5
;10.
;10.5
;11.
;11.5
;12.
;12.5
;13.
;13.5
;14.
;14.5

; no intensity = constant voltage
;(display-stream (until (RC1 (stream-map (lambda (x) (- x 1)) ones) 5) 20))
