(load "testing.scm")
; There is a cycle if a cdr points to a pair we have seen before.
; Note I think this does not detect all cycles ! Only ones where taking cdr recursively would loop indefinitely.

(define (has-cycle? x)
  (define (check-cycles x seen-before)
    (cond
      ((not (pair? x)) false)
      ((memq (cdr x) seen-before) true)
      (else
        (check-cycles (cdr x) (cons x seen-before))
        )
      )
    )

  (check-cycles x (list))
  )



(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x
  )

(define (last-pair x)
  (if (null? (cdr x))
    x
    (last-pair (cdr x))
    )
  )


(define z (make-cycle '(a b c)))
(check-equal "cycle from ex3.13 is detected" (has-cycle? z) true)

(define x '(a b c))
(set-car! x (cdr x))
(set-car! (cdr x) (cddr x))
x
;(last-pair x)

(check-equal "no false positive for a structure with shared data but no cycle" (has-cycle? x) false)


;(define (cycle? lst)
;  (define (iter lst pairlist)
;    (cond ((not (pair? lst)) #f)
;	  ((memq lst pairlist) #t)
;	  (else (iter (cdr lst) (cons lst pairlist)))))
;  (iter lst '()))

; Thanks ChatGPT for confirming this does not detect all cycles. Only simple ones through cdr.

; counter example:
;(define a (cons 1 2))
;(define b (cons a 3))
;(set-car! a b)  ; Create a cycle: b -> a -> b
;In this setup, a points to b through its car, and b points back to a through its car, forming a cycle. The list looks something like this:
;
;a is initially (1 . 2)
;b is (a . 3)
;After the set-car! operation:
;
;a becomes (b . 2)
;b remains (a . 3)
;This creates a cyclic structure where a's car points to b, and b's car points back to a.

;our procedure returns 'no cycle'.

