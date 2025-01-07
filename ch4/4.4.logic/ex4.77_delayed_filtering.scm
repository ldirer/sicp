; Other solutions:
; I looked at: https://www.inchmeal.io/sicp/ch-4/ex-4.77.html
; nice solution. I'm not sure it works with nested 'not' but did not test it.


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



; Adding promises to the frames. A frame is an associative list (like a list of key, value pairs).
; Adding promises as new items in that list. It would be cleaner to separate them, see comment in 'make-frame'.
(define (make-frame-promise promise-proc promise-vars) (list 'frame-promise promise-proc promise-vars))
(define (frame-promise-proc frame-promise) (cadr frame-promise))
(define (frame-promise-vars frame-promise) (caddr frame-promise))

; extra frame-related procedures, builds on top of frames.scm.
(define (add-frame-promise frame-promise frame)
  ; this returns a new frame, possibly 'failed.
  ; execute immediately if possible (all variables available), else attach a promise to the frame.
  (if (is-frame-promise-ready? frame-promise frame)
    ((frame-promise-proc frame-promise) frame)
    (cons frame-promise frame)
    )
  )

(define (frame-promises frame)
  (filter (lambda (item) (eq? (type item) 'frame-promise)) frame)
  )

(define (frame-bindings frame)
  (filter (lambda (item) (not (eq? (type item) 'frame-promise))) frame)
  )

(define (make-frame bindings promises)
  ; just stuff everything in a big list :)
  (append bindings promises)

  ; we could have used something like the following, but it changes the way we construct a frame (ex: an empty frame is no longer the empty list)
  ; I'm not sure how many changes that would imply. But I don't like that they are in other files.
  ; So I used a (less efficient) solution that let me not change that interface.
  ;(define (make-frame bindings promises)
  ;  (list 'frame bindings promises)
  ;  )
  ;(define (frame-promises frame) (caddr frame))
  ;(define (frame-bindings frame) (cadr frame))
  )

(define the-empty-frame (make-frame '() '()))

; note extend may now return a 'failed frame.
; this is (already) handled by the rules/pattern matching code, such frames will be discarded.
(define (extend variable value frame)
  (define next-bindings (cons (make-binding variable value) (frame-bindings frame)))
  (define next-frame (make-frame next-bindings (frame-promises frame)))

  (apply-frame-promises #f next-frame)
  )




; new lisp-value and negate
(define (lisp-value call frame-stream)
  (define promise-required-vars (unbound-vars call the-empty-frame))
  (define (lv-promise-proc frame)
    (if (execute (instantiate call frame (lambda (v f) (error "Unknown pat var -- LISP-VALUE" v))))
      frame
      'failed
      )
    )
  (define lv-frame-promise (make-frame-promise lv-promise-proc promise-required-vars))
  (stream-filter (lambda (f) (not (eq? f 'failed))) (stream-map (lambda (frame) (add-frame-promise lv-frame-promise frame)) frame-stream))
  )

(define (negate operands frame-stream)
  (define promise-required-vars (unbound-vars (negated-query operands) the-empty-frame))
  (define (n-promise-proc frame)
    ; we need to force promise evaluation here. Otherwise we'll look at a stream of stuff that should be filtered out and call it 'ok'.
    (if (stream-null? (stream-force-evaluate-promises (qeval (negated-query operands) (singleton-stream frame))))
      frame
      'failed
      )
    )
  (define n-frame-promise (make-frame-promise n-promise-proc promise-required-vars))
  (stream-filter (lambda (f) (not (eq? f 'failed)))
    (stream-map
      (lambda (frame) (add-frame-promise n-frame-promise frame))
      frame-stream
      )
    )
  )

(define (stream-force-evaluate-promises frame-stream)
  (stream-filter (lambda (f) (not (eq? f 'failed))) (stream-map (lambda (f) (apply-frame-promises #t f)) frame-stream))
  )


; OPTIMIZE: PERFORM FILTERING AS SOON AS POSSIBLE.
; Don't add a frame filter if all variables are already bound.
; I think only 'and/conjoin' can add bindings to a frame coming from a 'not/lisp-value' after the fact.
; We would want to react to new bindings being added.
; -> I ended up 'reacting' in the `extend` proc, which is the entry point to add a variable to a frame. Makes a lot more sense.
; Maybe: attach a list of unbound variables to the promises
; when the frame is extended, go through the promises, run the promises that can be run.
; that means we need a way for extend to return a frame that will be removed.
; 'failed is a natural choice because it is already handled by the pattern and rule matching code...
; I think it's easier to try to run the promises every time than to keep track of exactly which variables are unbound.
; say the promise needs ?p. ?p is bound to ?q which is unbound. Next we could have ?q bound to a value *or* ?p bound to a value.
; both make the promise applicable.



(define (is-frame-promise-ready? frame-promise frame)
  (define promise-vars (frame-promise-vars frame-promise))
  (null? (unbound-vars promise-vars frame))
  )

(define (apply-frame-promises force? frame)
  ; force?: force evaluation of promises even if they are not ready. Only used as a last resort (ex: printing results)
  ; because it has the issues we're trying to fix.
  ; I think the best system would print a warning of some sort when forced to evaluate promises that are not ready (=a 'not' with unbound variables).
  (define (promise-apply-recursively frame-without-filters promises-to-process promises-processed-as-not-ready)
    ; for each proc, check if all variables are bound.
    ; if so, apply it. Returns a 'failed frame or the frame with the proc removed from the list of procs.
    (cond
      ((null? promises-to-process) (make-frame (frame-bindings frame) promises-processed-as-not-ready))
      ((or force? (is-frame-promise-ready? (car promises-to-process) frame-without-filters))
        ; apply the filter.
        ; if failed, the frame should be removed from the stream. Done by returning a 'failed frame.
        ; if ok, the promise has run - remove it from the frame.
        (let ((filter-result ((frame-promise-proc (car promises-to-process)) frame-without-filters)))
          (if (eq? filter-result 'failed)
            'failed
            (promise-apply-recursively frame-without-filters (cdr promises-to-process) promises-processed-as-not-ready)
            )
          )
        )
      (else (promise-apply-recursively frame-without-filters (cdr promises-to-process) (cons (car promises-to-process) promises-processed-as-not-ready)))
      )
    )

  ; we have to apply a filter on the frame **without filters**.
  ; Otherwise a negation filter will try to evaluate the negated query with a frame that contains a filter (itself!).
  ; the evaluation function will apply that filter, infinite loop.
  (define frame-without-filters (make-frame (frame-bindings frame) (list)))
  (promise-apply-recursively frame-without-filters (frame-promises frame) (list))
  )


; adapted from the 'instantiate' procedure
(define (unbound-vars exp frame)
  (define (collect-unbound exp)
    (cond
      ((var? exp)
        (let ((binding (binding-in-frame exp frame)))
          (if binding
            (collect-unbound (binding-value binding))
            (list exp)))
        )
      ((pair? exp)
        (append (collect-unbound (car exp)) (collect-unbound (cdr exp)))
        )
      (else '()))
    )
  (collect-unbound exp)
  )


