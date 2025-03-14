(define (gcd a b) 
  (cond ((= b 0) a)
        (else (gcd b (remainder a b)))
  )
  )


(gcd 206 40)


; how many steps using normal-order evaluation ? applicative-order ?


; normal order:
(gcd 206 40)
(gcd 40 (remainder 206 40))
(gcd (remainder 206 40) (remainder 40 (remainder 206 40)))
(gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))
; above first argument is 4, second argument is 2
(gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))
; finally we reached 0 in the second argument
(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))

; AH. this is wrong. remainder calls *will* be evaluated when we test for (= b 0).

; counting remainder calls evaluated
(gcd 206 40)
(gcd 40 (remainder 206 40))
(gcd 6 (remainder 40 6))  ; 1
(gcd 4 (remainder 6 4))  ; 2
(gcd 2 (remainder 4 2))  ; 3
; finally we reached 0 in the second argument
; returns 2  ; 4 calls to `remainder`.

; At this stage I was like: isn't this the same in the applicative order ?...
; the book asks to count the number of times remainder is evaluated in normal-order and in applicative-order.
; I don't think there's a difference here.


; **ANSWER**
; My understanding of normal order evaluation was way wrong.
; Things are basically evaluated **multiple times**.  
; the first sequence is the 'more correct' one, when we get inside `gcd` the second argument is indeed evaluated 
; *once* in (= b 0), but it is still passed 'lazily' to the recursive call (!).


; Here's a mental model of what's happening: 
; (define (gcd lazy_function_giving_a lazy_function_giving_b) 
;   (cond ((= lazy_function_giving_b() 0) lazy_function_giving_a())
;         (else (gcd lazy_function_giving_b (remainder lazy_function_giving_a lazy_function_giving_b)))
;         )
;   )
; Looks like... Maybe we could actually *implement* something based on that !


; PP With Maud: this explains the 18 calls to 'remainder' !
; /home/laurent/programming/sicp/scheme_runner.sh /home/laurent/programming/sicp/ch1/ex1.20.scm | grep "REMAINDER CALL" | sort | uniq -c
; emulate normal order by wrapping values in functions
; calling the function is the way we represent evaluating the value.
(define (gcd_normal f_a f_b)
  (cond ((begin (newline) (display "IF") (= (f_b) 0)) (begin (newline) (display "THEN") (f_a)))
        (else (begin (newline) (display "ELSE") (gcd_normal f_b (remainder_normal f_a f_b))))
        )
  )


(define (remainder_normal f_a f_b)
  (lambda () (begin (newline) (display "REMAINDER CALL") (remainder (f_a) (f_b))))
  )


;(define (test) (
;
;                 define (test-helper stuff count-a count-b)
;                 (define count-a 0)
;                 (define count-b 0)
;                 (gcd_normal (lambda () (begin () 206)) (lambda () (begin (newline) (display 40) 40)))
;
;                 ))
;)

(gcd_normal (lambda () (begin (newline) (display "LAME") (display 206) 206)) (lambda () (begin (newline) (display "LAME") (display 40) 40)))


