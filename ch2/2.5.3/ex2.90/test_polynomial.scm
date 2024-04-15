(load "ch2/2.5.3/generic.scm")
(load "ch2/2.5.3/ex2.90/termlist_generics.scm")
(load "ch2/2.5.3/ex2.90/polynomial.scm")
(install-polynomial-package)

;x**5 + 2x**4 + 3x**2 - 2x - 5
(define p-sparse (make-polynomial-sparse 'x (list '(5 1) '(4 2) '(2 3) '(1 -2) '(0 -5))))

(make-termlist-sparse (list '(5 1) '(4 2) '(2 3) '(1 -2) '(0 -5)))


(add p-sparse p-sparse)
; expected: 2x**5 + 4x**4 + 6x**2 - 4x - 10
; Value: (polynomial x sparse (5 (scheme-number . 2)) (4 (scheme-number . 4)) (2 (scheme-number . 6)) (1 (scheme-number . -4)) (0 (scheme-number . -10)))

(define p-dense (make-polynomial-dense 'x (list 1 2 0 3 -2 -5)))
p-dense
(add p-dense p-dense)
;; expected: 2x**5 + 4x**4 + 6x**2 - 4x - 10
;
(add p-dense p-sparse)


(sub p-dense p-dense)
;Value: (polynomial x dense (scheme-number . 0) (scheme-number . 0) (scheme-number . 0) (scheme-number . 0) (scheme-number . 0) (scheme-number . 0))

(sub p-sparse p-dense)
;Value: (polynomial x dense (scheme-number . 0) (scheme-number . 0) 0 (scheme-number . 0) (scheme-number . 0) (scheme-number . 0))

; there's a mix between 'scheme-number' and regular, untagged numbers. I think it's because I use a version of generics that assumes 'scheme-number' when there is no tag, but still add the tag.
; Ex:
; (add 1 1)
;;Value: (scheme-number . 2)
; I think I could fix that by removing the 'scheme-number tag for all returned values in the scheme-number package.
; (but this package is used in other exercises so I don't want to do it).

(sub p-dense p-sparse)
