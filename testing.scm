(define (check-equal test-name actual expected)
  (if (equal? actual expected)
    (begin
      (display "test passed: ")
      (display test-name)
      (display "\n")
      )
    (error "test failed: expected actual =>" expected actual)
    )
  )


;(check-equal "meta test" 1 0)