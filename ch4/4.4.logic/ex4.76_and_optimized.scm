(load "ch4/4.4.logic/streams.scm")

; Limitations of this 'optimized and' implementation mentioned in https://www.inchmeal.io/sicp/ch-4/ex-4.76.html and https://eli.thegreenplace.net/2008/02/09/sicp-sections-442-444
; Since we evaluate each clause independently, we might try to evaluate a `not` with unbound variables. Not good.
; Also, recursive rules don't always play well with independent evaluation, because it means they get evaluated on *all assertions* instead of on a reduced set.
; sometimes the assumption that it's evaluated on a reduced set of frames is what makes the query matching terminate.


(define (stream-product streams)
  (cond
    ((stream-null? streams) (cons-stream '() the-empty-stream))
    (else
      (stream-flatmap
        (lambda (first)
          (stream-map (lambda (partial) (cons first partial)) (stream-product (cdr streams)))
          )
        (car streams)
        )
      )
    )
  )


(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op
      (car sequence)
      (accumulate op initial (cdr sequence))
      )
    )
  )


(define (conjoin-optimized conjuncts frame-stream)
  (define outputs-streams (map (lambda (conjunct) (qeval conjunct frame-stream)) conjuncts))

  (define candidate-frame-combinations-stream (stream-product outputs-streams))
  (stream-flatmap
    (lambda (frames)
      (define result (accumulate join-frames '() frames))
      (if result
        ; return the frame we found that merges all sets of bindings in a compatible way
        (singleton-stream result)
        ; incompatibilities in bindings - no result
        the-empty-stream
        )
      )
    candidate-frame-combinations-stream)
  )


; > You must implement a procedure that takes two frames as inputs, checks whether the bindings in
; > the frames are compatible, and, if so, produces a frame that merges the two sets of bindings.
; > This operation is similar to unification.
; we can use the unify procedure through 'extend-if-possible'.
(define (join-frames fone ftwo)
  (cond
    ((or (eq? fone 'failed) (eq? ftwo 'failed)) #f)
    ((null? ftwo) fone)
    ((null? fone) ftwo)
    (else
      (join-frames
        (cdr fone)
        (extend-if-possible (binding-variable (car fone)) (binding-value (car fone)) ftwo)
        )
      )
    )
  )

