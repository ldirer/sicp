;use amb
(load "ch4/4.3.1.amb/language.scm")

; Adding (some sort of) adjective and adverb parsing.
(define adjectives '(adj funny furious fluffy freaky feisty frail))
(define adverbs '(adv carefully carelessly calmly coldly casually))


(define (parse-simple-noun-phrase)
  (define (parse-adjectives)
    ; failing to parse will stop recursion
    (define adj (parse-word adjectives))
    (amb adj (list 'adjective-list adj (parse-adjectives)))
    )

  (amb (list 'simple-noun-phrase
             (parse-word articles)
             (parse-word nouns)
         )
    (list 'adjective-noun-phrase
          (parse-word articles)
          (parse-adjectives)
          (parse-word nouns)
      )
    (list 'simple-noun-phrase)
    )
  )

; Parsing adverbs: I took a different approach compared with adjectives.
; this results in different data structures as output
; Multiple adjectives are parsed into a 'adjective-list tagged list, here we follow the pattern
; introduced in the book with 'maybe-extend': this results in nesting data structures.
(define (parse-verb-adverb)
  (define (maybe-extend verb-adverb)
    (amb
      verb-adverb
      (maybe-extend (list 'verb-adverb verb-adverb (parse-word adverbs)))
      )
    )

  (maybe-extend (parse-word verbs))
  )

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
      (maybe-extend (list 'verb-phrase verb-phrase (parse-prepositional-phrase))))
    )
  (maybe-extend (parse-verb-adverb))
  )


(parse '(the student sleeps))
(parse '(the funny furious student lectures))
;(sentence (adjective-noun-phrase (article the) (adjective-list (adj funny) (adj furious)) (noun student)) (verb lectures))

(parse '(the funny furious student with the feisty cat lectures))
;(sentence
; (noun-phrase
;   (adjective-noun-phrase
;     (article the) (adjective-list (adj funny) (adj furious)) (noun student)
;   )
;   (prep-phrase
;     (prep with)
;     (adjective-noun-phrase
;       (article the) (adj feisty) (noun cat)
;     )
;   )
; )
; (verb lectures)
;)

(parse '(the student lectures carefully))
; (sentence (simple-noun-phrase (article the) (noun student)) (verb-adverb (verb lectures) (adv carefully)))

(parse '(the student lectures casually carefully))
; note the nested structure of 'verb-adverb lists
;(sentence (simple-noun-phrase (article the) (noun student)) (verb-adverb (verb-adverb (verb lectures) (adv casually)) (adv carefully)))
