
; > The evaluators in sections 4.1 and 4.2 do not determine what order operands are evaluated in.
; > We will see that the amb evaluator evaluates them from left to right.
; > Explain why our parsing program wouldn't work if the opearnds were evaluated in some other order.


; if operands were evaluated in some other order - say right to left - all the bits like:
;(list 'sentence
;      (parse-noun-phrase)
;      (parse-verb-phrase)
;  )
; would be parsed in reverse.
;

; I believe it would be fixed if we introduced variables as follows:
; (define noun-phrase (parse-noun-phrase))
; (define verb-phrase (parse-verb-phrase))
; (list 'sentence noun-phrase verb-phrase)
; But there are also (at least) amb recursive calls that would need to be adjusted.

