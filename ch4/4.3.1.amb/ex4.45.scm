(load "ch4/4.3.1.amb/language.scm")

(pp (parse '(the professor lectures to the student in the class with the cat)))

try-again
try-again
try-again
try-again
; Not sure about these answers. I didn't look very carefully, and it was a bit more subtle than I thought.
; 1. the professor lectures to the student, in the class, with the cat.
; 2. the professor lectures to the student in the class with the cat (the one class that hosts a cat)
; 3. the professor lectures to the student in the class, with the cat (as a co-teacher)
; 4. the professure lectures to the student [who is] in the class, with the cat (the professor lectures with the cat).
; 5. the professor lectures to the student [who is] in the class with the cat (the one class that hosts a cat)

;;;; Amb-Eval input:
;(pp (parse '(the professor lectures to the student in the class with the cat)))
;;;; Starting a new problem
; (sentence
; (simple-noun-phrase (article the) (noun professor))
; (verb-phrase
;  (verb-phrase
;   (verb-phrase
;    (verb lectures)
;    (prep-phrase (prep to) (simple-noun-phrase (article the) (noun student))))
;   (prep-phrase (prep in) (simple-noun-phrase (article the) (noun class))))
;  (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))
;
;;;; Amb-Eval value:
;#!unspecific
;
;;;; Amb-Eval input:
;try-again
; (sentence
; (simple-noun-phrase (article the) (noun professor))
; (verb-phrase
;  (verb-phrase
;   (verb lectures)
;   (prep-phrase (prep to) (simple-noun-phrase (article the) (noun student))))
;  (prep-phrase
;   (prep in)
;   (noun-phrase
;    (simple-noun-phrase (article the) (noun class))
;    (prep-phrase (prep with)
;                 (simple-noun-phrase (article the) (noun cat)))))))
;
;;;; Amb-Eval value:
;#!unspecific
;
;;;; Amb-Eval input:
;try-again(sentence
; (simple-noun-phrase (article the) (noun professor))
; (verb-phrase
;  (verb-phrase
;   (verb lectures)
;   (prep-phrase
;    (prep to)
;    (noun-phrase
;     (simple-noun-phrase (article the) (noun student))
;     (prep-phrase (prep in)
;                  (simple-noun-phrase (article the) (noun class))))))
;  (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))
;
;;;; Amb-Eval value:
;#!unspecific
;
;;;; Amb-Eval input:
;try-again
; (sentence
; (simple-noun-phrase (article the) (noun professor))
; (verb-phrase
;  (verb lectures)
;  (prep-phrase
;   (prep to)
;   (noun-phrase
;    (noun-phrase
;     (simple-noun-phrase (article the) (noun student))
;     (prep-phrase (prep in) (simple-noun-phrase (article the) (noun class))))
;    (prep-phrase (prep with)
;                 (simple-noun-phrase (article the) (noun cat)))))))
;
;;;; Amb-Eval value:
;#!unspecific
;
;;;; Amb-Eval input:
;try-again
; (sentence
; (simple-noun-phrase (article the) (noun professor))
; (verb-phrase
;  (verb lectures)
;  (prep-phrase
;   (prep to)
;   (noun-phrase
;    (simple-noun-phrase (article the) (noun student))
;    (prep-phrase
;     (prep in)
;     (noun-phrase
;      (simple-noun-phrase (article the) (noun class))
;      (prep-phrase (prep with)
;                   (simple-noun-phrase (article the) (noun cat)))))))))
;
