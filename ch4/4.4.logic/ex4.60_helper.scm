; used in exercise 4.60
; Chat wrote this function.
; A very similar but better solution: https://eli.thegreenplace.net/2008/02/08/sicp-section-441
; it just applies `write-to-string` to the lists and compares that.
; a lot easier than this, even easier than pasting ChatGPT's work.
(define (compare-symbol-lists< list-1 list-2)
  (let loop ((l1 list-1) (l2 list-2))
    (cond
      ((null? l1) (not (null? l2)))          ; Both lists are empty -> equal
      ((null? l2) #f)                        ; l1 has more elements -> l1 > l2
      ((string<?
         (symbol->string (car l1))   ; Compare first elements
         (symbol->string (car l2))) #t) ; l1 < l2
      ((string>?
         (symbol->string (car l1))
         (symbol->string (car l2))) #f) ; l1 > l2
      (else (loop (cdr l1) (cdr l2))))))     ; Move to next elements



(compare-symbol-lists< '(apple apple) '(apple banana))
; true
(compare-symbol-lists< '(apple banana) '(apple banana))
; false
(compare-symbol-lists< '(apple banana cherry) '(apple banana))
; false
