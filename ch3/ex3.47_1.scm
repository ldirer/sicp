; implement semaphore
; a. using mutex
; b. using atomic test-and-set! operations.
(load "ch3/3.4.2/parallel.scm")
(load "ch3/3.4.2/sleep.scm")
; I'm not sure our version of make-mutex _really_ works with the implementation of 'parallel-execute'. But whatever.
(load "ch3/3.4.2/serializer.scm")


(define (make-interval a b)
  (define (iter i result-range)
    (cond
      ((< i a) result-range)
      (else (iter (- i 1) (cons i result-range)))
      )
    )
  (iter (- b 1) '())
  )

(make-interval 1 5)
; expected: 1 2 3 4

;a. Using mutex
; I first thought: a list of mutexes, we acquire the first one we can, try to acquire the semaphore again if none (busy-waiting).
; 'acquire would return the mutex, so we can use that to 'release.
; But this doesn't work with the mutex object from the book... 'acquire already loops so we cannot try to acquire
; all mutexes once, then loop.
; This approach is, in fact, doomed!!
; below what I had started writing.

; I also completely got blindsided, I kept thinking of this as N mutexes... When it can 'just' be one mutex protecting a counter.
; TODO: implement that.

;(define (make-semaphore n)
;  (define mutexes (map (lambda (i) (make-mutex)) (make-interval 0 n)))
;
;  (define (acquire-any ms)
;    (cond
;      ((null? ms) false)
;;      THIS PART IS NOT GOING TO WORK. EVER, AT LEAST WITH THE MUTEX IMPLEMENTATION FROM THE BOOK.
;      ((car ms) 'acquire)
;      (acquire-any (cdr ms))
;      )
;    )
;
;  (define (the-semaphore m)
;    (cond
;      ((eq? m 'acquire)
;        acquire
;        ACQUIRE ANY MUTEX
;        )
;      ((eq? m 'release) error "use the mutex object returned by the call to acquire to release")
;      )
;    )
;  the-semaphore
;  )

(define (make-semaphore n)
  (define count 0)
  (define m (make-mutex))

  (define (acquire)
    (m 'acquire)
    (cond
      ((< count n)
        (set! count (+ count 1))
        (m 'release)
        )
      (else
        (m 'release)
        (acquire)) ; loop, 'busy-wait' to acquire
      )
    )

  (define (release)
    (m 'acquire)
    (set! count (- count 1))
    (m 'release)
    )

  (define (the-semaphore action)
    (cond
      ((eq? action 'acquire) (acquire))
      ((eq? action 'release) (release))
      )
    )

  the-semaphore
  )


(define start (get-universal-time))

(define (elapsed)
  (- (get-universal-time) start)
  )

(define (print-done name)
  (display "process ")
  (display name)
  (display " done after ")
  (display (elapsed))
  (display "s")
  (newline)
  )
