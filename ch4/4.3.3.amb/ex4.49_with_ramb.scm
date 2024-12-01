; use myamb
(load "ch4/4.3.1.amb/language.scm")

(define (cadr a) (car (cdr a)))
(define (cddr a) (cdr (cdr a)))
(define (caddr a) (car (cddr a)))

(define (parse-word word-list)
  ; reminder that word-list is (word-type ...words)
  ; ignore the input ('*unparsed') and just generate words

  ; original approach - without apply
;  (define (helper words)
;    (if (null? words)
;      (ramb)
;      ; this is not great! ramb here will take the first word with a 50% probability
;      ; I added apply to my analyzer because I don't know how to do without it.
;       (ramb (car words) (helper (cdr words)))
;      )
;    )
;  (cons (car word-list) (helper (cdr word-list)))

  ; I think my apply is fundamentally broken BUT it does the job for this particular piece of code.
  ; Calling _that_ a success :).
  (list (car word-list) (apply ramb (cdr word-list)))
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
(define (range low high)
  (if (>= low high)
    '()
    (cons low (range (+ low 1) high))
    )
  )


(define sentences (map (lambda (item) (collect-words (parse '()))) (range 0 100)))

(define first-picked-nouns (map (lambda (sentence) (cadr sentence)) sentences))

(define (count item items)
  (cond
    ((null? items) 0)
    ((eq? item (car items)) (+ (count item (cdr items)) 1))
    (else (count item (cdr items)))
    )
  )

(define (pick-probability noun)
  (/ (count noun first-picked-nouns) (length first-picked-nouns))
  )

(pick-probability 'student)
; Hopefully close to (/ 1 (length nouns)). Experimentally: yes.

(parse '())
(collect-words (parse '()))
try-again
try-again
try-again
(collect-words (parse '()))
try-again
try-again
(collect-words (parse '()))
try-again
try-again

(collect-words (parse '()))
(collect-words (parse '()))
try-again

; samples:
; (the coat eats in a student to a student to the professor)
; (the student eats with the student for the class)
; (a professor eats with the professor to the coat)
; (a coat lectures with the cat)
; A little underwhelming, I'll say.
