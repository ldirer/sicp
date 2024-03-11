(load "ch2/ex2.69.scm")

(define pop-pairs (list
                    (list 'A 2)
                    (list 'GET 2)
                    (list 'SHA 3)
                    (list 'WAH 1)
                    (list 'BOOM 1)
                    (list 'JOB 2)
                    (list 'NA 16)
                    (list 'YIP 9)
                    )
  )


(make-leaf-set pop-pairs)
(define pop-tree (generate-huffman-tree pop-pairs))


(define message '(Get a job
Sha na na na na na na na na
Get a job
Sha na na na na na na na na
Wah yip yip yip yip yip yip yip yip yip
Sha boom))


(decode (encode message pop-tree) pop-tree)
; expected: the original message

(length (encode message pop-tree))

; Encoded message is 84 bits.
; Say we had used a fixed-length code.
; 8 symbols in alphabet: 3 bits required as a minimum.
; Since :
; (length message)
; ; 36
; (* 36 3)
; 108 bits would have been used.





