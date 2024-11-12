(load "ch4/4.3.1.amb/third_party/ch4-ambeval.scm")
; thought there might be a bug with that but we're all good.
(let->combination '(let ((i (an-integer-between low high)))
                     (let ((j (an-integer-between i high)))
                       let ((k (an-integer-between j high)))
                       (require (= (+ (* i i) (* j j)) (* k k))) (list i j k))
                     ))