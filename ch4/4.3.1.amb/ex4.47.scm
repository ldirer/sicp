(load "ch4/4.3.1.amb/language.scm")

; Louis Reasoner's suggestion:
(define (parse-verb-phrase)
  (amb
    (parse-word verbs)
    (list 'verb-phrase
          (parse-verb-phrase)
          (parse-prepositional-phrase)
      )
    )
  )
(define (parse-noun-phrase)
  (amb
    (parse-simple-noun-phrase)
    (list 'noun-phrase
          (parse-simple-noun-phrase)
          (parse-prepositional-phrase)
      )
    )
  )

(define *unparsed* '(lectures to the student))
(parse-verb-phrase)

;try-again

; This causes an infinite loop!
;(define *unparsed* '(the student))
;(parse-verb-phrase)


; Explanation: Scheme tries (parse-word verbs).
; It fails. It tries the second option.
; The second option calls `parse-verb-phrase`, which tries (parse-word verbs).
; No progress is made, we are looping indefinitely.
; The function behaves correctly when parsing succeeds, but loops indefinitely when it fails.

; The difference with the original (below) is that the original *forced* parsing a verb
; before trying to extend.
; So if it fails to parse a verb, it does not try to do more.

; original version:
;(define (parse-verb-phrase)
;  (define (maybe-extend verb-phrase)
;    (amb verb-phrase
;      (maybe-extend (list 'verb-phrase verb-phrase (parse-prepositional-phrase))))
;    )
;  (maybe-extend (parse-word verbs))
;  )


; If we interchange the order of expressions in the amb call, the infinite loop happens every time.
;
(define (parse-verb-phrase)
  (amb
    (list 'verb-phrase
          (parse-verb-phrase)
          (parse-prepositional-phrase)
      )
    (parse-word verbs)
    )
  )

; infinite loop too
;(define *unparsed* '(lectures to the student))
;(parse-verb-phrase)

; I guess that was a hint to help figuring out what was wrong with the function.