; a. We can complete Alyssa's proposition:

(define (simple-stream-flatmap proc s)
  (simple-flatten (stream-map proc s))
  )

(define (simple-flatten stream)
  (stream-map
    stream-car
    (stream-filter (lambda (substream) (not (stream-null? substream))) stream))
  )


; b. Does the query system's behavior change if we change it in this way?
; Hmmmm. It looks like maybe we will force computation of `stream-filter` (returning a stream but that forces evaluation of the first element due to how streams are implemented).
; that does not seem like much of a change...
; I could test that but I'm too lazy.
; Steps to confirm this:
; - new file with custom negate, lisp-value, find-assertions.
; - a log in lisp-value to print the record being evaluated.
; - new repl-74.scm that loads these.
; - on a simple query like in ex4.74_logic.scm [...]
; Ok I'll try it.
; SO. The experiments are in the other files. I was not able to show a difference in the query system.
; I got a bit confused. It's true that the first element of a stream is precomputed.
; but in (stream-map f stream), we apply f to the also already-precomputed element of stream.
; --> I think there could still be a difference. The first element of stream filter means we need to find a non-empty stream. that was not done exactly at this point before.
; But I think it is only a side-effect timing thing.
; unless perhaps we have an infinite stream of empty streams... My understanding isn't solid enough to test for that kind of edge case.
; I did manage to show the point about streams and logs that could cause a change in behavior in the 'streams_test.scm' file.


(define (lisp-value call frame-stream)
  (simple-stream-flatmap
    (lambda (frame)
      (newline)
      (display "Alyssa's lisp-value for frame: ")
      (display frame)
      (if (execute
            (instantiate call frame (lambda (v f) (error "Unknown pat var -- LIST-VALUE" v)))
            )
        (singleton-stream frame)
        the-empty-stream)
      )
    frame-stream
    )
  )
