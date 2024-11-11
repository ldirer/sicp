; this file is meant to run inside the lazy intepreter



(define (cons x y)
  ; uppercase because the name is special (used as a tag to identify lazy lists)
  (lambda (METHOD-LAZY-LIST) (METHOD-LAZY-LIST x y))
  )

(define (car z) (z (lambda (p q) p)))
(define (cdr z) (z (lambda (p q) q)))

(define (cadr z) (car (cdr z)))
(define (caddr z) (car (cdr (cdr z))))
(define (cadddr z) (car (cdr (cdr (cdr z)))))

(define (list-ref items n)
  (if (= n 0)
    (car items)
    (list-ref (cdr items) (- n 1))
    )
  )


(define (map proc items)
  (if (null? (car items))
    '()
    (cons
      (proc (car items))
      (map proc (cdr items))
      )
    )
  )

(define (scale-list items factor)
  (map (lambda (x) (* x factor)) items)
  )

(define (add-lists l1 l2)
  (cond
    ((null? l1) l2)
    ((null? l2) l1)
    (else (cons
            (+ (car l1) (car l2))
            (add-lists (cdr l1) (cdr l2))
            )
      )
    )
  )

(define ones (cons 1 ones))
(define integers (cons 1 (add-lists ones integers)))

(begin
  (newline)
  (display (list-ref integers 17))
  )
