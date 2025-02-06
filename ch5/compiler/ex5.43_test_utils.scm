; I wanted to check if 'lookup-variable-value' was present in the instructions. Automatically.
; I thought it would be quick and easy to convert the instruction list to a string...
(define (instructions->string instructions)
  ; Chat-generated
  (define (flatten lst)
    (cond ((null? lst) '())        ; If the list is empty, return an empty list
      ((pair? (car lst))       ; If the first element is a pair (list), flatten it
        (append (flatten (car lst)) (flatten (cdr lst))))
      (else (cons (car lst) (flatten (cdr lst))))))
  ;  (flatten '((1 2) (3 (4 5)) 6))  ; => '(1 2 3 4 5 6)
  ;  (flatten '((define u 1) (define v 2) (+ u v))) ; => '(define u 1 define v 2 + u v)


  (define (to-string x)
    (cond
      ((null? x) "()")
      ((number? x) (number->string x))
      (else (symbol->string x))
      )
    )

  (define (interleave a b)
    (cond
      ((null? b) a)
      ((null? a) b)
      (else (cons (car a) (cons (car b) (interleave (cdr a) (cdr b)))))
      )
    )

  (define (make-list item n)
    (cond
      ((= n 0) '())
      (else (cons item (make-list item (- n 1))))
      )
    )

  ; need to convert empty lists to symbols
  (let ((flattened (flatten instructions)))
    (string-concatenate (interleave (map to-string flattened) (make-list " " (length flattened))))
    )
  )


;; Chat-generated
(define (count-substring str substr)
  (define (starts-with-at? str substr start)
    (let loop ((s1 start) (s2 0))
      (cond ((= s2 (string-length substr)) #t)  ; If we've matched the entire `substr`
        ((or (= s1 (string-length str))    ; If `str` ends before `substr` finishes
           (not (char=? (string-ref str s1) (string-ref substr s2)))) #f)
        (else (loop (+ s1 1) (+ s2 1)))))) ; Continue matching characters

  (define (count-from-index str substr index)
    (if (>= index (string-length str))  ; Stop if we're past the end of `str`
      0
      (if (starts-with-at? str substr index) ; Check if `substr` starts here
        (+ 1 (count-from-index str substr (+ index 1))) ; Count + Recurse
        (count-from-index str substr (+ index 1)))))    ; Recurse without counting

  (count-from-index str substr 0))  ; Start searching from index 0
