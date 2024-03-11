
; > What is the order of growth in the number of steps needed to encode a symbol? [ex 2.68]
; n: number of symbols
; at each recursion step we lookup the symbol in a set of symbols: O(n) assuming unordered list representation for sets.
; The number of recursion steps depends on the shape of the tree and the symbol itself.
; Worst case should be O(n) (worst case is the scenario from the previous exercise - 2.71).
; So O(n**2) worst case.
; Best case O(1) for recursion steps, O(n) for encode-symbol.