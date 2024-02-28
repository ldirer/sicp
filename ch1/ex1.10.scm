
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

(A 1 10)
; 2**9 * 2 ?  ; correct - 1024

(A 2 4)
; A(1, A(2, 3)) = 2 ** A(2, 3) = 2 ** (2 ** (2 ** 2)) = 2 ** 16
; 65536

(A 3 3)
; A(2, A(3, 2)) = A(1, A(2, A(3, 2) - 1)) = 2 ** A(2, A(3, 2) - 1)
; A(3, 2) = A(2, A(3, 1)) = A(2, 2) = A(1, A(2, 1)) = 2 ** 2 = 4
; hence:
; A(2, A(3, 2)) = 2 ** A(2, 4 - 1) = 2 ** (A(1, A(2, 2))) = 2 ** (2 ** 4)
; 65536 



(define (f n) (A 0 n))
(define (g n) (A 1 n))
(define (h n) (A 2 n))
(define (k n) (* 5 n n))

; k(n) = 5 * n**2
; Mathematical definitions for f, g, h:
; f(n) = 2 * n
; g(n) = 2 ** n
; h(n) = g(h(n - 1)) = 2 ** (2 ** [...] (2 ** 2)) considering (h(1) = 2)
; includes n terms. h(2) = 4. h(3) = 2 ** (2 ** 2) = 16 ...


