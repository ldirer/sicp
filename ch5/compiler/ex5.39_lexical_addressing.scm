(define (make-lexical-address frame-number displacement-number)
  (list frame-number displacement-number)
  )

(define (lexical-address-frame-number addr) (car addr))
(define (lexical-address-displacement-number addr) (cadr addr))

(define (lexical-address-lookup lexical-address environment)

  (let ((frame-number (lexical-address-frame-number lexical-address))
         (displacement-number (lexical-address-displacement-number lexical-address))
         )
    (let ((value (get-variable-with-offset
                   (frame-values (get-ancestor-frame environment frame-number))
                   displacement-number)))
      (if (eq? value '*unassigned*)
        (error "looked up an *unassigned* value, should not happen -- lexical-address-lookup" lexical-adress)
        value
        )
      )
    )
  )


(define (lexical-address-set! lexical-address value environment)
  (let ((frame-number (lexical-address-frame-number lexical-address))
         (displacement-number (lexical-address-displacement-number lexical-address))
         )
    (set-variable-with-offset! (frame-values (get-ancestor-frame environment frame-number)) value displacement-number)
    )
  )

(define (get-variable-with-offset frame-values displacement-number)
  (cond
    ((null? frame-values) (error "unbound variable, no values left to skip, remaining displacement" displacement-number))
    ((= displacement-number 0) (car frame-values))
    (else (get-variable-with-offset (cdr frame-values) (- displacement-number 1)))
    )
  )

(define (get-ancestor-frame env frame-number)
  (cond
    ((eq? env the-empty-environment) (error "unbound variable, no frames left to skip, remaining frame number " frame-number))
    ((= frame-number 0) (first-frame env))
    (else (get-ancestor-frame (enclosing-environment env) (- frame-number 1)))
    )
  )


(define (set-variable-with-offset! frame-values value displacement-number)
  (cond
    ((null? frame-values) (error "unbound variable, no values left to skip, remaining displacement" displacement-number))
    ((= displacement-number 0) (set-car! frame-values value))
    (else (set-variable-with-offset! (cdr frame-values) (- displacement-number 1)))
    )
  )
