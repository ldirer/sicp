(load "testing.scm")
; two new things here
; 1. values can be under an arbitrary number of keys
; 2. The number of keys is not the same for every value !
; This is pretty different from what we had.
; "math" might be linked to a value *and* "math" "other" still exist.
; We can probably change the 'head' of subtables to include the value if any (turning the structure into a pair).
; though it might break things, there was a nice symmetry before that...
; Maybe it's simpler to add a (nil, value) record to the "math" table when there's a value under "math".



; BUT. We can just use the previous exercise's version with a one dimensional table and lists as keys.
; We need a 'same-key?' function that can compare lists by value (equal? works).
