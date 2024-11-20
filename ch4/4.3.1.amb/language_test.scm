;use amb
(load "ch4/4.3.1.amb/language.scm")

(parse '(the student with the cat sleeps in the class))

(parse '(the student sleeps))

(parse '(the student with the cat with the coat sleeps))
; (sentence (noun-phrase
; (noun-phrase (simple-noun-phrase (article the) (noun student))
; (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))
; )
; (prep-phrase (prep with) (simple-noun-phrase (article the) (noun coat)))
; ) (verb sleeps))