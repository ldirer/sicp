;from book
(define (front-ptr queue) (car queue))
(define (rear-ptr
          queue) (cdr queue))
(define (set-front-ptr! queue item)
  (set-car! queue item))
(define (set-rear-ptr!
          queue item)
  (set-cdr! queue item))


(define (empty-queue? queue)
  (null? (front-ptr queue)))

(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
    (error "FRONT called with an empty queue" queue)
    (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
            (set-front-ptr! queue new-pair)
            (set-rear-ptr! queue new-pair)
            queue)
      (else
        (set-cdr! (rear-ptr queue) new-pair)
        (set-rear-ptr! queue new-pair)
        queue))))

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
          (error "DELETE! called with an empty queue" queue))
    (else (set-front-ptr! queue (cdr (front-ptr queue)))
      queue)))

;from exercise
(define q1 (make-queue))
(insert-queue! q1 'a)
;((a) a)
(insert-queue! q1 'b)
;((a b) b)
(delete-queue! q1)
;((b) b)
(delete-queue! q1)
;(() b)

; Ben's examples above display the queue representation as a pair.
; The first element is a pointer to a list with the queue elements, so that's what is displayed.
; The second element is a pointer to the last item in the list.
; As for the last statement (showing '(() b)') it's an implementation detail that the data structure still has a pointer to b.
; It knows the queue is empty and the selector functions will behave accordingly.


(define (print-queue q) (front-ptr q))
(define q1 (make-queue))
(insert-queue! q1 'a)
;Value: ((a) a)
(print-queue q1)
;Value: (a)
(insert-queue! q1 'b)
;Value: ((a b) b)
(print-queue q1)
;Value: (a b)
(delete-queue! q1)
;Value: ((b) b)
(print-queue q1)
;Value: (b)
(delete-queue! q1)
(print-queue q1)
;Value: ()
