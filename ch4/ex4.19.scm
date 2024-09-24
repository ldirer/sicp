(define (interesting)
  (let ((a 1))
    (define (f x)
      (define b (+ a x))
      (define a 5)
      (+ a b))
    (f 10))
  )
(interesting)


; Three (!) options in this case
; 1. "Sequential evaluation" b evaluates to 11 since a was 1, then a is defined to be 5. Sum is 16. Ben Bitdiddle.
; 2. Error because a is "unassigned" when b is evaluated according to the transform rule for simultaneous variable definitions. Alyssa P Hacker.
; 3. "Truly simultaneous definitions": hence a should already be 5 when b is evaluated. Sum is 20. Eva Lu Ator.


; I favor 2. I think it's a lot less confusing!
; It's also what Python does (see below). You can't both use a global and reassign to it (or redefine it).
; The book mentions Eva's version makes sense but is difficult to implement in a "general, efficient" manner.
; I am a bit confused maybe?
; How would we handle reciprocal definitions?

;(let ((a 1))
;  (define (f x)
;    (define b (+ a x))
;    (define a (+ b 1))
;    (+ a b))
;  (f 10)
;  )

; I'm not sure how to implement Eva's point of view.
; It requires sorting definitions based on their "dependencies".
; A couple difficulties:
; 1. Such a sort order might not always exist.
; 2. the analysis to build the "dependencies" requires knowledge of scopes. It can't be just a syntax transformation (in my understanding).


; QUESTION:
; My version of Scheme does return 16. Which is said to be **incorrect** by the book (footnote 26)!!



; Python example: see associated file