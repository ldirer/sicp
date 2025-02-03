
(define (display-newline a) (newline) (display a))
(define (display-list items)
  (for-each display-newline items)
  )
