(load "testing.scm")

(define (make-table same-key?)
  (define (assoc key records)
    (cond ((null? records) false)
      ((same-key? key (caar records)) (car records))
      (else (assoc key (cdr records)))))

  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable
              (assoc key-1 (cdr local-table))))
        (if subtable
          (let ((record
                  (assoc key-2 (cdr subtable))))
            (if record (cdr record) false))
          false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable
              (assoc key-1 (cdr local-table))))
        (if subtable
          (let ((record
                  (assoc key-2 (cdr subtable))))
            (if record
              (set-cdr! record value)
              (set-cdr! subtable
                (cons (cons key-2 value)
                  (cdr subtable)))))
          (set-cdr! local-table
            (cons (list key-1 (cons key-2 value))
              (cdr local-table)))))
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
        ((eq? m 'insert-proc!) insert!)
        (else (error "Unknown operation: TABLE" m))))
    dispatch)
  )

(define operation-table (make-table equal?))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))


(put 1 1 "one")
(put 2 2 "two")


(check-equal "regular equal" (get 2.1 2) false)

(define (close-enough a b)
  (< (abs (- a b)) 0.2)
  )
(define operation-table (make-table close-enough))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))


(put 1 1 "one")
(put 2 2 "two")

(check-equal "custom equal" (get 2.1 1.9) "two")
(put 1.1 0.9 "new value!")
(check-equal "custom equal insert" (get 1 1) "new value!")
; not sure what the behavior should be here, we insert a value that is 'the same key', but what should the *exact value* be?
; I'm not sure I did what was expected.
; probably we want to insert all new values. And on 'get' pick the closest one ? idk.
; This solution didn't do anything special either: https://eli.thegreenplace.net/2007/10/04/sicp-section-333
(check-equal "custom equal insert" (get 1.1 1.15) "new value!")
