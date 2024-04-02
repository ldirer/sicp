(load "ch2/2.5.1/generic.scm")

; we need to add this to get the interaction mentioned in the book
; there's a `magnitude` builtin in my scheme, makes it confusing if we don't define it.
(define (magnitude z) (apply-generic 'magnitude z))

(define z (make-complex-from-real-imag 3 4))

(magnitude z)
; before we define selectors in the complex package, we get the error :
;No method for these types: APPLY-GENERIC (magnitude (complex))


; > Describe in detail why this works. As an example, trace through all the procedures called in evaluating
; > the expression (magnitude z) where z is the object shown in Figure 2.24.
; > In particular, how many times is apply-generic invoked? What procedure is dispatched to in each case?

(trace magnitude)
(trace apply-generic)
; also traced `magnitude` in rectangular and polar packages. Polar version is not called.
(magnitude z)
; 1 ]=> (magnitude z)
; [Entering #[compound-procedure 13 magnitude]
;     Args: (complex rectangular 3 . 4)]
; [Entering #[compound-procedure 14 apply-generic]
;     Args: magnitude
;           ((complex rectangular 3 . 4))]
; [Entering #[compound-procedure 14 apply-generic]
;     Args: magnitude
;           ((rectangular 3 . 4))]
; [Entering #[compound-procedure 12 magnitude]
;     Args: (3 . 4)]
; [5
;       <== #[compound-procedure 12 magnitude]
;     Args: (3 . 4)]
; [5
;       <== #[compound-procedure 14 apply-generic]
;     Args: magnitude
;           ((rectangular 3 . 4))]
; [5
;       <== #[compound-procedure 14 apply-generic]
;     Args: magnitude
;           ((complex rectangular 3 . 4))]
; [5
;       <== #[compound-procedure 13 magnitude]
;     Args: (complex rectangular 3 . 4)]
; ;Value: 5

; How this works: (magnitude z) uses `apply-generic` to look up the 'magnitude symbol. `z` has `(complex rectangular)` tag information.
; So it finds the `'magnitude '(complex)` procedure, runs that.
; In turn that procedure looks up the `'magnitude '(rectangular)` procedure and runs it.

; We see `apply-generic` is called twice. Once to get the 'magnitude procedure with the '(complex) tag.
; Once to get the 'magnitude procedure with the 'rectangular tag.
