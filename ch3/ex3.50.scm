(define (stream-map proc . argstreams)
  (if (null? (car argstreams))
    the-empty-stream
    ; Funny gotcha here!! I had 'stream-cons' instead of 'cons-stream' and it produced...
    ; maximum recursion depth errors!
    ; that's because the typo-ed procedure is not a special form, and its arguments are evaluated before the function call.
    ; so Scheme doesn't even know there's a typo, it's busy recursing in the arguments!
    ; realized that in ex3.53 where we use this stream-map.
    (cons-stream
      (apply proc (map stream-car argstreams))
      (apply stream-map
        (cons proc (map stream-cdr argstreams)))))
  )
