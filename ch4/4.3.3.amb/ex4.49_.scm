; use myamb
(load "ch4/4.3.1.amb/language.scm")

(define (cadr a) (car (cdr a)))
(define (cddr a) (cdr (cdr a)))

; > She reasons that by simply changing the procedure `parse-word` so that it ignores the "input sentence"
; > and instead always succeeds and generates an appropriate word, we can use the programs
; > we had built for parsing to do generation instead.
(define (parse-word word-list)
  ; reminder that word-list is (word-type ...words)
  ; ignore the input ('*unparsed') and just generate words
  (define drawn (random-in-list (cdr word-list)))
  (amb
    (list (car word-list) drawn)
    (parse-word word-list)
    )
  )


(define (random-in-list items)
  ; NOTE THAT 'random' STARTS WITH THE EXACT SAME SEED EVERY TIME THE INTERPRETER IS RESTARTED.
  ; So we get 'deterministic random' behavior and can expect generated sentences to be the same on every run.
  (nth (random (length (cdr items))) (cdr items))
  )

(define (nth n items)
  (cond
    ((= n 0) (car items))
    (else (nth (- n 1) (cdr items)))
    )
  )

(random-in-list (list 1 2 3 4))
; expected: one of 1, 2, 3, 4

(define (map proc items)
  (cond
    ((null? items) '())
    (else (cons (proc (car items)) (map proc (cdr items))))
    )
  )
(define (append-lists lists)
  (cond
    ((null? lists) '())
    ((null? (car lists)) (append-lists (cdr lists)))
    (else (cons (car (car lists)) (append-lists (cons (cdr (car lists)) (cdr lists))))
      )
    )
  )

(append-lists (list (list 1 2) (list 3 4)))
; expected: (1 2 3 4)

(define (collect-words sentence)
  (cond
    ((null? sentence) '())
    ((not (list? sentence)) (list sentence))
    ((memq (car sentence) '(sentence simple-noun-phrase article noun verb-phrase verb prep-phrase prep))
      ; 2 cases: sentence is a leaf like '(noun student), or it is something like '(noun-phrase (article the) (noun student))
      (if (list? (cdr sentence))
        ; I wanted to (apply append (map collect-words (cdr sentence))). But that would require n-ary apply.
        (append-lists (map collect-words (cdr sentence)))
        (collect-words (cdr sentence))
        )
      )
;    (else (list (car sentence)))
    (else (list "thought unreachable!"))
    )
  )

;
(parse '())
try-again
try-again
try-again
try-again
(collect-words (parse '()))
try-again
try-again
;(a cat lectures in a cat by a coat)
try-again
;(a cat lectures in a cat by a coat by a professor)
try-again
;(a cat lectures in a cat by a coat by a professor to a professor)
try-again
try-again
try-again
try-again
try-again
try-again

;It's clear that we will not produce anything interesting.
; One thing that people online did is use a dummy input.
; (https://www.inchmeal.io/sicp/ch-4/ex-4.49.html and https://eli.thegreenplace.net/2008/01/05/sicp-section-432)
; this limits the size of the sentence, which in turns forces the generator to 'explore' new sentences.

; At first I didn't use a random choice. I just picked the first valid word.
;;(the student studies for the student for the student for the student for the student for the student for the student)
;; well this is not great.
