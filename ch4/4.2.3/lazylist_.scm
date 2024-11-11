(load "ch4/4.2.2/lazy.scm")
(load "ch4/4.1.4/primitives.scm")

; this version of the file runs in the regular scheme.
(define global-env (setup-environment))

(eval '(begin
         (define (cons x y)
           (lambda (m) (m x y))
           )

         (define (car z) (z (lambda (p q) p)))
         (define (cdr z) (z (lambda (p q) q)))

         (define (list-ref items n)
           (if (= n 0)
             (car items)
             (list-ref (cdr items) (- n 1))
             )
           )

         (define (map proc items)
           (if (null? items)
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

         (newline)
         (display (list-ref integers 17))
         )
  global-env)
