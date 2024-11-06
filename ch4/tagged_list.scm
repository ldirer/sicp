;reminder: a list is a pair. (pair? my-list) is `true`.
(define (tagged-list? expr tag)
  (if (pair? expr)
    (eq? (car expr) tag)
    false
    )
  )
