
; broken proposal from the exercise:
(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (set! THE-ASSERTIONS (cons-stream assertion THE-ASSERTIONS))
  'ok
  )

; In the proposed implementation the line:
; (set! THE-ASSERTIONS (cons-stream assertion THE-ASSERTIONS))
; would turn THE-ASSERTIONS into an infinite stream of `assertion`.
; The let bindings in add-assertion! and add-rule! prevent that by making a copy of the stream.
