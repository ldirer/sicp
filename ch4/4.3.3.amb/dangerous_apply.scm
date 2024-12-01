; The issue I had recursive calls to 'ramb' that didn't quite achieve the expected uniform probability distribution.
; Not an equal chance to pick all words, ramb here will take the first word with a 50% probability.
; (ramb (car words) (helper (cdr words)))
; In terms of behavior, I would like `(apply ramb words)`.
; I decided to add apply to my analyzer so I could do just that.
; Now I have something that looks like it's working but is broken in a few fundamental ways.

(load "ch4/4.3.3.amb/utils")

(define (apply? exp) (tagged-list? exp 'apply))
(define (apply-proc exp) (cadr exp))
; only the last element passed to apply has to be a list and will be unwrapped
(define (apply-last-item-split exp) (split-last-item (cddr exp)))

;; As the pattern goes, I expected this to be easy.
;; I realized that the implementation below does not quite work: words is *not yet evaluated*.
;; 'Spreading' should happen on the *value* of the `words` variable. After it's been looked up.
;(define (analyze-apply exp)
;  (define split (apply-last-item-split exp))
;  (define last-item (split-element split))
;  (define rest (split-others split))
;  ; last-item is a list, using append effectively 'spreads' the arguments
;  (analyze (append (cons (apply-proc exp) rest) last-item))
;  )

(define (evaluate expr env)
  (define return-value 'unset)
  (ambeval expr env (lambda (value fail) (set! return-value value)) (lambda () (error "ambiguous values not allowed in this context")))
  return-value
  )

; Instead we need to *evaluate* the list argument before we can spread it.
; this is definitely weird territory.
(define (analyze-apply exp)
  (define split (apply-last-item-split exp))
  (define last-item (split-element split))
  (define rest (split-others split))
  (define proc (apply-proc exp))

  (lambda (env succeed fail)
    ; TERRIBLE. We change the order in which arguments are evaluated compared with usual.
    ; also calling analyze dynamically is a red flag for danger.
    ; I think it keeps things reasonably easy to understand in the happy scenario that I'm considering.
    ; in unhappy scenarios... like if evaluating has side effects... I wouldn't recommend it :).
    (define expanded (map (lambda (evaluated) (make-already-evaluated evaluated)) (evaluate last-item env)))
    ((analyze (append (cons (apply-proc exp) rest) expanded)) env succeed fail)
    )
  )



; this monstruosity emerged from the fact that `analyze` would run on `(ramb a b c)`, interpreting `a` as a variable.
;(define items (list 'a 'b 'c))
;(apply ramb items)
(define (make-already-evaluated value) (list 'already-evaluated value))
(define (already-evaluated? exp) (tagged-list? exp 'already-evaluated))
(define (already-evaluated-value exp) (cadr exp))
(define (analyze-already-evaluated exp)
  (lambda (env succeed fail) (succeed (already-evaluated-value exp) fail))
  )