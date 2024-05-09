(load "ch3/3.5/streams.scm")
(load "ch3/3.5/stream_utils.scm")

; partial sum
(load "ch3/ex3.55.scm")

; this is more subtle than I first noticed. n starts at 1. grows. Not a typical recursive definition, this is
; the 'implicit stuff' again.
(define (ln-two-summands n)
  (cons-stream
    (/ 1 n)
    (stream-map - (ln-two-summands (+ n 1)))
    )
  )

(display-stream (until (ln-two-summands 1) 15))

(define ln-two-stream (partial-sums (ln-two-summands 1.0)))


(display-stream (until ln-two-stream 20))
; 1.
;.5
;.8333333333333333
;.5833333333333333
;.7833333333333332
;.6166666666666666
;.7595238095238095
;.6345238095238095
;.7456349206349207
;.6456349206349207
;.7365440115440116
;.6532106782106782
;.7301337551337552
;.6587051837051838
;.7253718503718505
;.6628718503718505
;.7216953797836152
;.6661398242280596
;.718771403175428
;.6687714031754279


(define (euler-transform s)
  (let ((s0 (stream-ref s 0))   ; S_{n-1}
         (s1 (stream-ref s 1))  ; S_n
         (s2 (stream-ref s 2))) ;S_{n+1}
    (cons-stream (- s2 (/ (square (- s2 s1))
                         (+ s0 (* -2 s1) s2)))
      (euler-transform (stream-cdr s)))))

(display-stream (until (euler-transform ln-two-stream) 20))

; .7
;.6904761904761905
;.6944444444444444
;.6924242424242424
;.6935897435897436
;.6928571428571428
;.6933473389355742
;.6930033416875522
;.6932539682539683
;.6930657506744464
;.6932106782106783
;.6930967180967181
;.6931879423258734
;.6931137858557215
;.6931748806748808
;.6931239512121866
;.6931668512550866
;.6931303775344023
;.693161647077867
;.6931346368409872


(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s)))
  )


(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

(display-stream (until (accelerated-sequence euler-transform ln-two-stream) 20))
; 1.
;.7
;.6932773109243697
;.6931488693329254
;.6931471960735491
;.6931471806635636
;.6931471805604039
;.6931471805599445
;.6931471805599427
;.6931471805599454
;-nan.0
;-nan.0
;-nan.0
;-nan.0
;-nan.0
;-nan.0
;-nan.0
;-nan.0
;-nan.0
;-nan.0
;Guessing we hit a division by 0-like at some point due to limited float precision.

;Python:
;In [2]: math.log(2)
;Out[2]: 0.6931471805599453


; We are correct up to 10**-14 at just the 10th term of the last series.
; incredible gain, seemingly for free too. I am a little puzzled :)

; comment here puzzles me too
;https://math.stackexchange.com/questions/4530672/how-to-accelerate-the-convergence-of-a-power-series
;"Note that in applying Euler's transformation to a power series ∑n(−1)nbnxn;, the an
; in the transformation is bnxn;, not just bn.
; Thus you would have to calculate a separate (Δna)0
; for each value of x.
; I think you will find this significantly increases the amount of calculation, instead of decreasing it. –
; Paul Sinclair Sep 14, 2022 at 17:21"

; I get that what we're doing is at "fixed x" here in SICP.
; But whenever you actually compute a value you are at fixed x?.. And computing the terms is straightforward
; (not heavy in computation) in my understanding.
; Feels like we're getting a lot of "free lunch" here :)

; possible further reading: https://www.codeproject.com/Articles/5353031/Summation-of-Series-with-Convergence-Acceleration
; only skimmed.
; links to a translated publication from Euler himself (!): https://download.uni-mainz.de/mathematik/Algebraische%20Geometrie/Euler-Kreis%20Mainz/E212%20Kapitel%201RevisedVersion2.pdf
