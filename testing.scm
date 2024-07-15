(define (check-equal test-name actual expected)
  (if (equal? actual expected)
    (begin
      (display "\n")
      (display "test passed: ")
      (display test-name)
      (display "\n")
      'success!
      )
    (error (string-append "test '" test-name "' failed: expected/actual =>") expected "/" actual)
    )
  )


;(check-equal "meta test" 1 0)