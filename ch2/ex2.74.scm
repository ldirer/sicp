(load "ch2/ex2.73_get_put.scm")
; Disclaimer: this code wasn't really tested. We would need to implement a sample 'division package' to do so.

; > Show how such a strategy can be implemented with data-directed programming.
; Thoughts:
; We want a common interface for the different division representations.
; Each division could implement a package registering different procedures like:
; get-by-name employee-name
; selectors for an employee object (whose representation can remain division-specific):
; address
; salary



; a
(define (get-record name file)
  ((get 'get-record (division file)) name (content file))
  )

; division should be an identifier for the division.
; content is the 'file contents', basically the set of records (however they are organized)
(define (tag-with-division division content) (cons division content))
(define (division data) (car data))
(define (content data) (cdr data))

;sample division package:
(define (install-joy-division)
  (define (get-record name file)
    (define (custom-division-logic) ())
    ; the returned record is tagged with the division (its type)
    (tag-with-division 'joy (custom-division-logic))
    )
  (put 'get-record 'joy get-record)
  )

(install-joy-division)


;b.

(define (get-salary record)
  ((get 'get-salary (division record)) (content record))
  )


;c.

; adjusting `get-record`:
; I'm not sure why I felt like this was relevant.
; sure it's good to handle the case when a division did not register 'get-record... But not particularly relevant here.
(define (get-record name file)
  (let ((division-get-record (get 'get-record (division file))))
    (if (not division-get-record)
      false
      (division-get-record name (content file))
      )
    )
  )

(define (find-employee-record name files)
  ; let's assume `get-record` returns false if the record does not exist.
  (let ((results
          (filter
            (lambda (x) x)
            (map (lambda (file) (get-record name file)) files)
            )
          ))
    (if (null? results)
      false
      (car results)
      )
    )
  )

; d. When a new company is taken over, it acts as a new division.
; it needs to register the relevant methods by writing a package following the model given above (a.).