
; there's a difficulty here already : `term` has no type tag (unless we introduce it...).
; only term-list has one (in my initial plan). This breaks `apply-generic`, it expects type-tagged arguments.
;(define (adjoin-term term term-list) (apply-generic 'adjoin-term term term-list))
; using an explicit get instead.
; Use the version of 'adjoin-term' that preserves the type of 'term-list' (this is what apply-generic would do too).
(define (adjoin-term term term-list) (get 'adjoin-term (type-tag term-list) term term-list))

; not sure how much sense 'the-empty-termlist' makes as a generic. Probably zero !
; we would need one for each representation (in that case the methods are the same so we can just have one).
(define (the-empty-termlist-sparse) (get 'the-empty-termlist 'sparse))
(define (the-empty-termlist-dense) (get 'the-empty-termlist 'dense))

(define (first-term term-list) (apply-generic 'first-term term-list))
(define (rest-terms term-list) (apply-generic 'rest-terms term-list))

; maybe we could make our lives easier by noticing that these methods are identical in the two representations.
; specifically all things representing individual terms.
(define (empty-termlist? term-list) (apply-generic 'empty-termlist? term-list))
(define (make-term order coeff) (apply-generic 'make-term order coeff))
(define (order term) (apply-generic 'order term))
(define (coeff term) (apply-generic 'coeff term))

