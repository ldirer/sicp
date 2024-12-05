(load "testing.scm")
(load "ch4/4.4.logic/match.scm")

(define pattern '(supervisor (? . x) Ben))
(define assertion '(supervisor Alyssa Ben))
(define assertion2 '(supervisor Alyssa Alyssa))
(define matched (pattern-match pattern assertion '()))
(define matched2 (pattern-match pattern assertion2 '()))
(define matched-self (pattern-match pattern pattern '()))
(check-equal "simple pattern match" matched (list (make-binding '(? . x) 'Alyssa)))
(check-equal "simple pattern not match" matched2 'failed)

(check-equal "pattern should match itself" matched-self '())
