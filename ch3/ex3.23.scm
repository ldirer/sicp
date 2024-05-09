;extensive writeup here: https://people.eecs.berkeley.edu/~bh/61a-pages/Solutions/week10
; key ideas:
; the main new difficulty (compared with the regular queue) is rear-delete
; because we will need to go "up the queue" (backwards) to update the rear pointer.
; to solve for that, items of our queue need to point in both directions instead of just forward.
; It's very helpful (I found it necessary) to draw box/pointer diagrams of what the structure looks like.
; the deque is a front pointer and a rear pointer.
; each item is:
; [ | -]-> <next item = forwards pointer>
;  |
;  v
; [ backwards pointer | value ]
; To put it differently:
; (cons (cons backwards value) forwards)
; I did not find this easy at all !
; Much harder than I expected.
; maybe if I had written the selector/mutator functions for backwards/forwards pointers *first* it would have made it easier
; to reason about the code.
; (I ended up not writing them at all, I started by inlining stuff and now I want to move on)
(define (make-deque) (cons '() '()))

(define (front-ptr d) (car d))
(define (rear-ptr d) (cdr d))
(define (set-front-ptr! d p) (set-car! d p))
(define (set-rear-ptr! d p) (set-cdr! d p))

(define (empty-deque? d) (null? (front-ptr d)))

;selectors
(define (front-deque d) (car (front-ptr d)))
(define (rear-deque d) (car (rear-ptr d)))

;mutators
(define (front-insert-deque! d item)
  (let ((new-pair (cons (cons '() item) (front-ptr d))))
    (cond
      ((empty-deque? d)
        (set-rear-ptr! d new-pair)
        (set-front-ptr! d new-pair)
        )
      (else
        ; update next item backwards pointer
        (set-car! (car (front-ptr d)) new-pair)
        (set-front-ptr! d new-pair)
        )
      )
    )
  )
(define (rear-insert-deque! d item)
  (let ((new-pair (cons (cons (rear-ptr d) item) '())))
    (cond
      ((empty-deque? d)
        (set-rear-ptr! d new-pair)
        (set-front-ptr! d new-pair)
        )
      (else
        ; set-cdr! effectively adds the pair to the underlying list
        (set-cdr! (rear-ptr d) new-pair)
        (set-rear-ptr! d new-pair)
        )
      )
    )
  )
(define (front-delete-deque! d)
  (cond
    ((empty-deque? d) error "front-delete-deque! called on empty deque")
    ((null? (cdr (front-ptr d)))
      (set-rear-ptr! d '())
      (set-front-ptr! d '())
      )
    (else
      (set-front-ptr! d (cdr (front-ptr d)))
      ; cleanup a dangling pointer to (car front-ptr).
      ; since the second item pointed to the previous item in the queue (the one we just removed).
      (set-car! (car (front-ptr d)) '())
      )
    )
  )
(define (rear-delete-deque! d)
  (cond
    ((empty-deque? d) error "rear-delete-deque! called on empty deque")
    (else
      ; make sure front-ptr stops.
      ; (car rear-ptr) is a pair (backwards pointer, value), so caar is a backwards pointer.
      ; the solution linked at the top of this file uses helper-selector functions for pointers, it helps with clarity.
      (let ((previous (caar (rear-ptr d))))
        (cond ((null? previous)
                (set-rear-ptr! d '())
                (set-front-ptr! d '())
                )
          (else
            (set-cdr! previous '())
            (set-rear-ptr! d (caar (rear-ptr d))))
          )
        )
      )
    )
  )

(define (print-deque d)
  ; when we iterate map already 'unpacks' the queue for us so we get the pair ('backwards pointer' . value) as argument.
  (map (lambda (item) (cdr item)) (front-ptr d))
  )


(define d (make-deque))
(front-insert-deque! d 1)
(print-deque d)
(front-insert-deque! d 0)
(print-deque d)
(rear-insert-deque! d 2)
(print-deque d)
(rear-insert-deque! d 3)
(print-deque d)
(front-delete-deque! d)
(print-deque d)
(rear-delete-deque! d)
(print-deque d)
; expected: (1 2)
; test for some inserts after delete
(rear-delete-deque! d)
(print-deque d)
(rear-insert-deque! d 4)
(front-insert-deque! d 0)
(print-deque d)
; expected: (0 1 4)

; tests to check boundary conditions in deletion
(define d (make-deque))
(front-insert-deque! d 1)
(front-delete-deque! d)
(print-deque d)
; tests to check boundary conditions in deletion
(define d (make-deque))
(front-insert-deque! d 1)
(rear-delete-deque! d)
(print-deque d)
