(load "with_book_club/3.56.scm")

(define original-plus +)

(define (+ a b)
  (original-plus a b))

(define fibs
  (cons-stream 0
    (cons-stream 1
      (add-streams (stream-cdr fibs)
        fibs))))

(trace +)
;(stream-car fibs); 0 calls
;(stream-car (stream-cdr fibs)); 0 calls
;(stream-car (stream-cdr (stream-cdr fibs))); 1 call

(take fibs 2) ; 1 call --> HUUUUUGE PROBLEM !!!! (expected 0)
;(take (stream-cdr fibs) 1)
;(take fibs 4)
;(take (stream-cdr (stream-cdr fibs)) 0)
;(stream-cdr (stream-cdr fibs)); 1 call

;(define new-stream (stream-cdr (stream-cdr fibs)))



;(define-syntax cons-stream
;  (syntax-rules ()
;    ((_ x y) (cons x (delay y)))))
;
;
;(define (stream-car stream) (car stream))
;(define (stream-cdr stream) (force (cdr stream)))

; Rewriting fibs with delays
(define fibs
  (cons 0
    (delay (cons 1
             (delay (add-streams (force (cdr fibs))
                      fibs))))))

;0 1 1 2 3 5 8
;
;
;                          5
;          3                           2
;    2           1                 1       1
; 1     1       0 1              0   1
;0 1



