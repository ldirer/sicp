; need to comment out (query-driver-loop) in the other file to run this one.
; didn't want to bother with yet another repl file.
(load "ch4/4.4.logic/third_party/4.67.query.scm")

(define pattern (query-syntax-process '(notsure ?how ?works)))
(freevars pattern '())

(extend-history pattern '() '())
