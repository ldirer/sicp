; n=5

; symbols with frequencies
; C5 C4 C3 C2 C1
; 1 2 4 8 16
; Tree (without frequencies):
; I don't think it matters but I sort of switched right and left branches compared with the book's example.

;         C5,C4,C3,C2,C1
;         /           \
;     C5,C4,C3,C2     C1
;       /       \
;    C5,C4,C3   C2
;     /  \
;  C5,C4  C3
;   /\
; C5  C4


; Same thing for n=10, the tree is completely skewed.

; > In such a tree (for general n) how many bits are required to encode the most frequent symbol?
; > The least frequent symbol?

; Most frequent symbol: 1 bit.
; Least frequent symbol: n - 1 bits.
