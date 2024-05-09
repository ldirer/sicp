(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")
(load "ch3/ex3.79.scm")

;dv_c/dt = -i_L / C
;di_L/dt = (1/L) * v_c  - (R/L) * i_L

(define (RLC R L C dt)

  (define (streams vc0 iL0)
    (define vc (integral (delay dvc) vc0 dt))
    (define iL (integral (delay diL) iL0 dt))
    (define dvc (scale-stream iL (/ -1 C)))
    (define diL (add-streams (scale-stream vc (/ 1 L)) (scale-stream iL (- (/ R L)))))
    (cons iL vc)
    )
  streams
  )

; R=1 ohm, C=0.2 farad L=1 henry
; iL0=0 amps, vc0 = 10 volts
(define circuit (RLC 1 1 0.2 0.1))
(define i-and-v (circuit 10 0))

; iL at 1s
(stream-ref (car i-and-v) 1000)
; vc at 1s
(stream-ref (cdr i-and-v) 1000)

; iL at 100 seconds
(stream-ref (car i-and-v) 100000)
; expected ~0
; vc at 100 seconds
(stream-ref (cdr i-and-v) 100000)
; expected ~0


;results match those on: https://mk12.github.io/sicp/exercise/3/5.html#ex3.80
; I didn't check the theoretical RLC solutions
(display-stream-inline (until (car i-and-v) 20))
(display-stream-inline (until (cdr i-and-v) 20))
