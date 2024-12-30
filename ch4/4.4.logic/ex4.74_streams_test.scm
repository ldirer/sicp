(load "ch4/4.4.logic/ex4.74.scm")

(define (add-streams s1 s2) (stream-map + s1 s2))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 0 (add-streams ones integers)))

(stream-car integers)
(stream-car (stream-cdr integers))
(stream-car (stream-cdr (stream-cdr integers)))
; Value: 2

(define integers-streams-raw (cons-stream integers integers-streams-raw))

(define (with-log s)
  (stream-map (lambda (item) (newline) (display "LOG ITEM: ") (display item) item) s)
  )

; just defining this causes a log for the first stream to be displayed. As expected.
(define integers-streams (with-log integers-streams-raw))

; this also logs the first stream (empty).
(define uh-uh (with-log (cons-stream the-empty-stream integers-streams)))

; note how this logs a new, non-empty stream.
; if we had multiple times the empty stream at the front of uh-uh, we would even get *multiple logs*.
(stream-filter (lambda (substream) (not (stream-null? substream))) uh-uh)

; while this **does not log anything**
(stream-filter (lambda (substream) (not (stream-null? substream))) integers-streams)
