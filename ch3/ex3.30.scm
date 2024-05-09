; LIKELY INCORRECT UNTIL TESTED. ;(define (full-adder a b c-in s c-out))

(define (ripple-carry a-list b-list s-list carry-wire)
  ; note the ripple carry first adds a_n and b_n, producing c_{n-1}. It then proceeds 'downwards'.

  ; in iter, c-list **must** be a list with one more element than the other lists.
  (define (iter a-list b-list s-list c-list)
    (cond ((null? a-list) 'ok)
      (else
        (full-adder (car a-list) (car b-list) (car c-list) (car s-list) (cadr c-list))
        (iter (cdr a-list) (cdr b-list) (cdr s-list) (cdr c-list) (car c-list))
        )
      )
    )

  ;  (define c-n (make-wire))
  ;  (set-signal! c-n 0)


  ; This solution: https://eli.thegreenplace.net/2007/10/08/sicp-section-334
  ; does something neat with the c-lists. It creates c-in-list and c-out-list, putting the same wires in them.
  ; this makes the iter code very nicely symmetrical.
  ; I don't fully understand the details of the c-out-list construction though, it feels to me like there's one item too many in it.

  ; i don't know if the signal on C wires should be set to 0. The initial (c_n) carry is always 0. A bit of a 'static wire'.
  ; --> wires are initialized with a 0 signal so it's fine as it is.
  (define c-list (cons carry-wire (map (lambda (x) (make-wire)) a-list)))
  (iter (reverse a-list) (reverse b-list) (reverse s-list) (reverse c-list))
  )


; What is the delay needed to obtain the complete output from an n-bit ripple-carry adder,
; expressed in terms of the delays for and-gates, or-gates, and inverters?

; The delay is N times the delay of a full-adder.
; The delay of a full-adder is twice the delay of a half-adder + delay of or-gate.
; I'm going to assume the delay of a half-adder is 2*and-gate-delay+inverter-delay.
; It might be more complicated than that (there's an OR gate too, I feel like it might introduce difficult synchronisation issues!).

; So the ripple-carry delay for N bits: N * (2 * (2*and + inverter) + or) = 4 * N * and + 2 * N * inverter + N * or

