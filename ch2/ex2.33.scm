(define (square x) (* x x))


; from the book. Feels like it could be made tail recursive easily ?
; `initial` could store the result
(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op
      (car sequence)
      (accumulate op initial (cdr sequence))
      )
    )
  )

(define (map p sequence)
  (accumulate (lambda (x acc) (cons (p x) acc)) (list) sequence)
  )

(map square (list 1 2 3 4))
; expected: (1 4 9 16)


; it isn't necessarily super intuitive that this will produce items in the same order as Python's seq1 + seq2.
; makes sense when looking at 'accumulate' definition but not that straightforward.
(define (append seq1 seq2)
  (accumulate (lambda (x acc) (cons x acc)) seq2 seq1)
  )


(append (list 6 5 7) (list 1 2 3 4))
; expected (6 5 7 1 2 3 4)


(define (length sequence)
  (accumulate (lambda (x acc) (+ 1 acc)) 0 sequence)
  )


(length (list))
; expected: 0
(length (list 1 2 3 4))
; expected: 4
