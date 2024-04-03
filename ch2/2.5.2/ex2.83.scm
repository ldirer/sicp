(load "ch2/2.5.2/generic.scm")
; tower of types : integer, rational, real, complex
; I chose to call integer 'scheme-number'.

;there is no 'real' package but we would add this to it if it existed :
(define (raise-real r) (make-complex-from-real-imag r 0))
(put 'raise '(real) raise-real)

; added procedures to scheme-number and rational packages
; as well as a generic procedure to `generic`

(raise 3)
; expected: rational ..
(raise (raise 3))
; expected: complex ..
; I skipped real because we don't have a 'real' package.
