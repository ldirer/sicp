(load "testing.scm")
(load "ch2/2.5.2/apply.scm")
(load "ch2/2.5.3/ex2.90/termlist_sparse.scm")


(install-termlist-sparse-package)
; x**100 + 2x**2 + 1
(check-equal
  "first term"
  (first-term (list (list 100 1) (list 2 2) (list 0 1)))
  (list 100 1)
  )
