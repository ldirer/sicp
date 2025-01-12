(define (f) (define a 1))
;Value: f
(f)
;Unspecified return value
((f))
;The object #[constant 12 #x2] is not applicable.
;To continue, call RESTART with an option number:
; (RESTART 2) => Specify a procedure to use in its place.
; (RESTART 1) => Return to read-eval-print level 1.


; I had an error with the message above.
; When the scheme interpreter says "Unspecified return value", it means there is a return value, and it's "unspecified".
; Experimenting a bit, there seem to be multiple objects that map to 'unspecified'.
; The 12 and 13 hash might not be stable across interpreter runs.
; I got one where the `x` from (define x (begin)) was hashed to 14 (I think because I had another variable declaration before.
; But subsequent (define y (begin)) used the same object.
; Maybe it depends on when the variable is defined (and then it's cached, a singleton for all (begin) undefined).
; anyway! Does not seem reliable, but it's good to remember a #[constant xx xx] might just be an 'unspecific' object.

(pp (f))
;#[constant 12 #x2]
(hash-object #[constant 12 #x2])
;Value: 12
(hash-object (f))
;Value: 12


(define x (begin))
;Value: x
x

;Unspecified return value
(eq? x #@12)
;Value: #f

; this #[] syntax is: #[name hash output]
; name is the type of the object. hash is an id (result of calling hash on the object).
; not sure what output is. some custom representation of the object, can be missing.
;https://groups.csail.mit.edu/mac/ftpdir/scheme-7.4/doc-html/scheme_15.html#SEC136
(eq? x #[constant 12 #x2])
;Value: #f

(write x)
#!unspecific
;Unspecified return value
(pp #!unspecific)
#!unspecific
;Unspecified return value

(hash-object #!unspecific)
;Value: 13

(hash-object x)
;Value: 13

(f)
;Unspecified return value




; A CONFUSING SEQUENCE - (f) returns object hash 12 then hash 13... Let's just not rely on any of this :)
(define (f) (define a 1))
;Value: f
(f)
;Unspecified return value
(hash-object #!unspecific)
;Value: 12
(define x (begin))
;Value: x
x
;Unspecified return value
(hash-object #!unspecific)
;Value: 12
(pp x)
#!unspecific
;Unspecified return value
(pp (f))
#[constant 13 #x2]
;Unspecified return value