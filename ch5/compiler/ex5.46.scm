(load "ch5/compiler/compile_and_run.scm")

(define (fib-stats n)
  (define result '*undefined*)

  (define (set-result stats) (set! result stats))
  (compile-and-run
    `(begin
       (define (fib n)
         (if (< n 2)
           n
           (+ (fib (- n 1)) (fib (- n 2)))
           )
         )
       (fib ,n)
       )
    set-result
    )
  result
  )

; this was **without** < as open-coded primitive.
(map fib-stats (list 3 4 5 6 7 8 9))
;Value: ((stack-statistics 16 6) (stack-statistics 30 8) (stack-statistics 51 10) (stack-statistics 86 12) (stack-statistics 142 14) (stack-statistics 233 16) (stack-statistics 380 18))


; S_n: total number of pushes for (fib n)
;S_{n+2} = S_{n+1} + S_n + 5
;Let U_n = S_n + 5
;U_{n+2} = S_{n+2} + 5 = S_{n+1} + S_n + 5 + 5 = U_{n+1} + U_n
;(U_n) is a Fibonacci suite.
; U_3 = 16 + 5 = 21 = 7 * 3 = 7 * fib_4
; U_4 = 30 + 5 = 35 = 7 * 5 = 7 * fib_5
; Hence:
; U_n = 7 * fib_{n+1}
; S_n = 7 * fib_{n+1} - 5



; code from figure 5.12, with the extra save/restore from ex5.6 removed and an extra line to collect stats into a special register.
(define fibo-controller
  '(controller
     (perform (op initialize-stack))        ; extra - to reset stack stats when reusing the machine

     (assign continue (label fib-done))

     fib-loop
     (test (op <) (reg n) (const 2))
     (branch (label immediate-answer))
     ; recursive main course

     (save continue)
     (assign continue (label after-fib-n-1))
     (save n)
     (assign n (op -) (reg n) (const 1))
     (goto (label fib-loop))

     after-fib-n-1
     (restore n)

     (assign n (op -) (reg n) (const 2))
     (assign continue (label after-fib-n-2))

     (save val)

     (goto (label fib-loop))

     after-fib-n-2
     ; use n as a temporary register. We'll restore it later anyway.
     ; store the value of (fib (- n 1))
     (assign n (reg val))
     (restore val)
     (restore continue)
     (assign val (op +) (reg val) (reg n))
     (goto (reg continue))

     immediate-answer
     (assign val (reg n))
     (goto (reg continue))
     fib-done
     ; extra code to collect stats
     (assign stack-stats (op get-stack-statistics))
     )
  )

(define machine
  (make-machine
    '(b n val continue stack-stats)
    (list (list 'prompt-for-input prompt-for-input) (list 'read read) (list '= =) (list '- -) (list '+ +) (list '< <))
    fibo-controller))


(define (fibo-machine n)
  (set-register-contents! machine 'n n)
  (start machine)
;  (get-register-contents machine 'val)
  (get-register-contents machine 'stack-stats)
  )

; fibo values for (3 4 5 6 7 8): 2 3 5 8 13 21
(map fibo-machine (list 3 4 5 6 7 8))
;Value: ((stack-statistics 6 4) (stack-statistics 12 6) (stack-statistics 21 8) (stack-statistics 36 10) (stack-statistics 60 12) (stack-statistics 99 14))
; S_{n+2} = S_{n+1} + S_n + 3
; U_n = S_n + 3 is a fibonacci suite
; U_3 = 6 + 3 = 9 = 3*fib_4
; U_4 = 12 + 3 = 15 = 3*fib_5
; S_n = 3 * fib_{n+1} - 3

; **with < as open coded primitive**
;(map fib-stats (list 3 4 5 6 7 8 9))
;Value: ((stack-statistics 6 4) (stack-statistics 12 6) (stack-statistics 21 8) (stack-statistics 36 10) (stack-statistics 60 12) (stack-statistics 99 14) (stack-statistics 162 16))


; | Mode                                      | n pushes                     | max-depth       |
; |-------------------------------------------|------------------------------|-----------------|
; | Special purpose                           | 3 * fib_{n+1} - 3            | 2 * (n - 1)     |
; | Interpreted                               | 56 * fib_{n+1} - 40          | 5 * n + 3       |
; | Compiled*                                 | 7 * fib_{n+1} - 5            | 2 * n           |
; | Compiled with < as open-coded primitive   | 3 * fib_{n+1} - 3            | 2 * (n - 1)     |
; *: used open-coded primitives but not <, only +, =.


; I also don't understand why the exercise mentions "the ratio of stack operations will not approach a limiting value that is independent of n".
; My results are consistent with: https://www.inchmeal.io/sicp/ch-5/ex-5.46.html