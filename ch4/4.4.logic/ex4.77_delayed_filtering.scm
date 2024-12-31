; > In section 4.4.3 we saw that `not` and `lisp-value` can cause the query language to give
; > "wrong" answers if these filtering operations are applied to frames in which variables are unbound.
; > Device a way to fix this shortcoming.
; > One idea is to perform the filtering in a "delayed" manner by appending to the frame a "promise"
; > to filter that is fulfilled only when enough variables have been bound to make the operation possible.
; > We could wait to perform filtering until all other operations have been performed.
; > However, for efficiency's sake, we would like to perform filtering as soon as possible so as to cut down on the number of intermediate frames generated.


; the issue with (not (supervisor (john) ?p)) is that if *any* assertion matches the query, the not-query results will be the empty stream.
; when really we wanted to wait until ?p was bound by another `and` clause for instance.
; see test file for an example.


; THINKING THROUGH THIS:
; The book says "we could wait to perform filtering until all other operations have been performed".
; We could also reach the end of all operations and still have unbound variables though.
; I guess that's a case we need to handle anyway.
; Maybe start by implementing just that?

; Say we return a promise. Now we have mixed stream of frames and *promises*.
; --> no no. The text says 'appending to the frame a "promise"'. So we attach the promise to the frame.
; these promises should also know when they are ready... maybe list unbound variables?
; then when given a frame, check if all of these are bound.

; we're doing an 'and'. we might receive a promise instead of a frame in our frame stream.
; What do we do with that.
; I think this means that the 'and' procedure has to change too.
; Only 'and' can effectively complete a frame.
; OR we need to integrate the promise in the frame data structure without breaking its interface.


; promise is a function that takes a frame and returns either an empty stream of a singleton stream with the frame.
(define (make-augmented-frame frame promise) (list 'augmented-frame frame promise))
(define (augmented-frame-frame aug-frame) (cadr aug-frame))
(define (augmented-frame-promise aug-frame) (caddr aug-frame))

; return a frame-stream with all delayed computations done
(define (force-augmented-frame-stream aug-frame-stream)
  (stream-flatmap (lambda (aug-frame) ((augmented-frame-promise aug-frame) (augmented-frame-frame aug-frame))) aug-frame-stream)
  )


; will this break everything? I think not. It does not feel very clean... But I want to see if I can get a quick solution working.
(define (make-frame-filter filter-proc) (cons 'frame-filter filter-proc))
(define (frame-filter-proc frame-filter) (cdr frame-filter))
(define (add-frame-filter filter-proc frame)
  (cons (make-frame-filter filter-proc) frame)
  )


(define (apply-frame-filters frame)
  ;    (display "frame=")
  ;    (display frame)
  ;    (newline)
  (define collected-filters (filter (lambda (item) (eq? (type item) 'frame-filter)) frame))
  (define collected-filter-procs (map frame-filter-proc collected-filters))
  (define frame-without-filters (remove-frame-filters frame))
  ; we have to combine the filters on the frame **without filters**.
  ; Otherwise a negation filter will try to evaluate the negated query with a frame that contains a filter (itself!).
  ; the evaluation function will apply that filter, infinite loop.
  (if (and-recursively collected-filter-procs frame-without-filters)
    frame-without-filters
    #f
    )
  )


(define (remove-frame-filters frame)
  (filter (lambda (item) (not (eq? (type item) 'frame-filter))) frame)
  )

(define (and-recursively proc-list arg)
  (cond
    ((not arg) arg)
    ((null? proc-list) arg)
    ((and-recursively (cdr proc-list) ((car proc-list) arg)))
    )
  )


(define (qeval query frame-stream)
  ;  (display "qeval query=")
  ;  (display query)
  ;  (newline)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
      (stream-map remove-frame-filters (stream-filter apply-frame-filters (qproc (contents query) frame-stream)))
      (stream-map remove-frame-filters (stream-filter apply-frame-filters (simple-query query frame-stream)))
      )
    )
  )

(define (lisp-value call frame-stream)
  (define (lv-filter frame)
    (execute
      (instantiate call frame (lambda (v f) (error "Unknown pat var -- LIST-VALUE" v)))
      )
    )
  (stream-map (lambda (frame) (add-frame-filter lv-filter frame)) frame-stream)
  )

(define (negate operands frame-stream)
  (define (n-filter frame) (stream-null? (qeval (negated-query operands) (singleton-stream frame))))
  (stream-map (lambda (frame) (add-frame-filter n-filter frame)) frame-stream)
  )
