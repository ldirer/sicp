(load "ch3/ex3.66.scm")

; s_i, t_j, u_k such that i <= j <= k
(define (triples s t u)
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      ; here it's critical that we have this extra stream and not try to map on (pairs t (cdr u))
      ; because t and (cdr u) would not be 'aligned'. The pairs procedure does not know about numbers, it just pairs
      ; items based on their position in the stream.
      ; Basically for it to make sense in our context we almost certainly want to call pairs/triples on streams that
      ; are 'aligned'.
      (stream-map (lambda (x) (list (stream-car s) (stream-car t) x)) (stream-cdr u))
      (interleave
        (stream-map (lambda (x) (cons (stream-car s) x)) (pairs (stream-cdr t) (stream-cdr u)))
        (triples (stream-cdr s) (stream-cdr t) (stream-cdr u))
        )
      )
    )
  )

;(display-stream (until (triples integers integers integers) 40))

;trying to confirm by showing < 3... expects 10 elements.
(define filtered (stream-filter (lambda (triple)
                 (and
                   (< (car triple) 4)
                   (< (cadr triple) 4)
                   (< (caddr triple) 4)
                   )
                 ) (triples integers integers integers)))
; this loops indefinitely looking for more items (hopelessly)
;(display-stream (until filtered 40))



; A nicer solution from https://mk12.github.io/sicp/exercise/3/5.html#ex3.69
(define (triples s t u)
  (cons-stream
   (list (stream-car s) (stream-car t) (stream-car u))
   (interleave
    (stream-map (lambda (x) (cons (stream-car s) x))
                (stream-cdr (pairs t u)))
    (triples (stream-cdr s)
             (stream-cdr t)
             (stream-cdr u)))))


(define pythagorean-triples
  (stream-filter
    (lambda (triple) (= (+ (expt (car triple) 2) (expt (cadr triple) 2)) (expt (caddr triple) 2)))
    (triples integers integers integers)
    )
  )

; this is sloooooooow AND continuously errors after the 6th triplet with stuff like
;GC #219 15:43:28: took:   0.10 (100%) CPU,   0.10 (100%) real; free: 4330
;Aborting!: out of memory
(display-stream (until pythagorean-triples 40))