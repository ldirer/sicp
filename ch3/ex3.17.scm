(load "testing.scm")

(define (count-pairs x)
  (define seen-before (list))
  (define (count-pairs-rec x)
    (define (pair-and-not-already-seen? x)
      (and (pair? x) (not (memq x seen-before)))
      )

    (if (pair-and-not-already-seen? x)
      (begin
        (set! seen-before (cons x seen-before))
        (+ (count-pairs-rec (car x))
          (count-pairs-rec (cdr x))
          1))
      0)
    )

  (count-pairs-rec x)

  )


(check-equal "simple" (count-pairs '(a b c)) 3)

; example from previous exercise (returned 7 with the bugged version)
(define x '(a b c))
(set-car! x (cdr x))
(set-car! (cdr x) (cddr x))
(check-equal "previous exercise 7 should be 3" (count-pairs x) 3)
