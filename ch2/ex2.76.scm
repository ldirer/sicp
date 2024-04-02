; As a large system with generic operations
; evolves, new types of data objects or new operations may
; be needed. For each of the three strategies—generic opera-
; tions with explicit dispatch, data-directed style, and message-
; passing-style—describe the changes that must be made to a
; system in order to add new types or new operations. Which
; organization would be most appropriate for a system in
; which new types must often be added? Which would be
; most appropriate for a system in which new operations
; must often be added?

; First let's recap what each approach means. I'm not 100% confident.
; A. Generic operations with explicit dispatch:
; In the generic procedures we have something like:
; if sum then deriv-sum
; if product then deriv-product

; Pro: Go to source \o/
; Con: everything is centralized, see below what needs to be done on new type/new operation.

; B. Data-directed style
; - implementations are isolated in packages.
; - they register procedures inside a symbol-to-procedure-by-type table using `put`.
; - the generic method applies `(get op type)`.

; C. Message-passing-style
; - Implementations return a procedure object ('dispatch').
; - generic method calls 'dispatch' with the name of the operation (same as 'op' in data-directed style).
; - All the code is inside the local implementation (in the 'dispatch' procedure).


; A.
; When a new type is added:
; 1. add a case inside each generic procedure, calling the specialized function.
; this means we need to change the code of every generic procedure.

; When a new operation is added:
; 1. Write a new generic procedure dispatching to `new-op-[type]` for each type.

; B. New type is added:
; 1. Write a new package for the type (install-package-newtype). Register it by calling the function.
; New operation is added:
; 1. Write the new generic operation (straightforward)
; 2. Go and modify every package so that they register the new operation.

; C. New type is added:
; 1. Write the new type. Idk there's not much more to it.
; New operation is added:
; 1. Make it so that the 'dispatch' functions all handle the new operation.

; My feeling is B and C are very similar.
; I'm not sure why one should be favored over the other.

; If new types are often added, B looks like a good fit.
; C isn't bad either I think.
; If new operations are often added, C is a good fit. But then B is too ?
; Honestly even A doesn't sound that terrible. It's just that you need to handle all
; cases inside one big function which is tedious.


; another solution (I wish it explained things a bit more in that case):
;https://eli.thegreenplace.net/2007/09/09/sicp-section-24



