(list 1 (list 2 (list 3 4)))
;Value: (1 (2 (3 4)))

; box and pointer representation:

; (1 (2 (3 4)))     (2 (3 4))     (3 4)
;
; [. , .]        -> [. , .]     -> [. , .] -> [. , /]
;
; [1]               [2]            [3]        [4]


; Interestingly this looks exactly like (list 1 2 3 4) if we don't include the first line in the representation
; (the line with 'list inputs').


; Tree:
;       (1 (2 (3 4)))
; 1                 (2 (3 4))
;               2           (3 4)
;                         3       4

