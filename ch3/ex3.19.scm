; same exercise as the previous one, but we want to use a constant amount of space. Hmmm.
; we could probably use x as the 'seen before' list.
; since we are traversing in order.
; we look up our current (cdr x) in the list.
; if it's there at an index that is lower than the one we're at, there's a cycle.

; I skipped this but looked at the solution here: https://people.eecs.berkeley.edu/~bh/61a-pages/Solutions/week10.
; interesting. There are two solutions. The most optimized one is not the approach I described above.
; the other one resembles it (not exactly what I decribed though), but is definitely *not* as straightforward as I thought !
; could be a good exercise later.
;

