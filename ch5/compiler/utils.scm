
(define (display-newline a) (newline) (display a))
(define (display-list items)
  (for-each display-newline items)
  )

(define (display-instruction-comparison seq1 seq2)
  ; line by line comparison. Useful if sequences align.
  (display-list (map
                  (lambda (pair) (let ((a (car pair)) (b (cadr pair))) (if (equal? a b) (list 'ok a) (list 'nok a b))))
                  (zip
                    seq1
                    seq2
                    )
                  )
    )
  )
