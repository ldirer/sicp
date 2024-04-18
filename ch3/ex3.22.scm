(define (make-queue)
  ; note we're initializing front-ptr and rear-ptr to nil pointers. Basically that is NOT initializing them.
  ; this happens later. They need to be pointers to the same underlying list.
  (let ((front-ptr '())
         (rear-ptr '()))

    (define (empty-queue?) (null? front-ptr))
    (define (insert-queue! item)
      (let ((new-pair (list item)))
        (cond
          ((empty-queue?)
            (set! front-ptr new-pair)
            ; we can't have an empty list here since we want to use 'set-cdr!' in the else expression. We need a pair.
            (set! rear-ptr new-pair)
            )
          (else
            ; set-cdr! on rear pointer should update the data front pointer points to.
            (set-cdr! rear-ptr new-pair)
            (set! rear-ptr new-pair)
            )
          )
        )
      )
    (define (delete-queue!)
      (cond
        ((empty-queue?) error "delete-queue! called on an empty queue")
        (else (set! front-ptr (cdr front-ptr)))
        )
      )

    (define (dispatch m)
      (cond
        ((eq? m 'front-ptr) front-ptr)
        ((eq? m 'rear-ptr) rear-ptr)
        ((eq? m 'insert-queue!) insert-queue!)
        ((eq? m 'delete-queue!) delete-queue!)
        )
      )
    dispatch
    )
  )

(define (front-ptr queue) (queue 'front-ptr))
(define (rear-ptr queue) (queue 'rear-ptr))
;; i don't think we want set-front-ptr! here. private
;(define (set-front-ptr! queue item) ((queue 'set-front-ptr!) item))
;(define (set-rear-ptr! queue item) ((queue 'set-rear-ptr!) item))

(define (insert-queue! queue item) ((queue 'insert-queue!) item))
(define (delete-queue! queue) ((queue 'delete-queue!)))

(define (print-queue q) (front-ptr q))
(define q1 (make-queue))
(insert-queue! q1 'a)
(print-queue q1)
(insert-queue! q1 'b)
(print-queue q1)
(delete-queue! q1)
(print-queue q1)
(delete-queue! q1)
(print-queue q1)
