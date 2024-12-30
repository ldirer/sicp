; to detect that we entered a loop where we are about to process a query that we are already working on, we could:

; - store a history as a list of (pattern . frame) pairs. The history is a stack: we should remove items once we're done with them.
; - in simple-query, try to lookup the pattern. See the frames associated with it.
;--> The place to do this is not in simple-query. Pattern matching on assertions cannot create a loop.
; Only rules can create loops.
; When we find a match for a rule conclusion, we want to evaluate the body only if it's not something we have already done before.

; iterate on frame-stream, if a frame matches one of the history frame then raise an error.
; "matches" in this context=variables are 'as free'.
;
; How do we compare a (pattern, frame) with historical items?
; The resolution of variables (that refer to variables, etc) is done in unify-match and pattern-match...
; If we lookup a variable it may appear as bound to ?other-var. That does not tell us if it's free or not.
; Maybe we can use instantiate for that purpose:
; compare frames by comparing the values of (instantiate pattern frame (lambda (var frame) ?free))

; I ended up writing my solution in the 4.67/ directory.
; Heavily inspired by https://github.com/l0stman/sicp/blob/master/4.67.query.scm (file copied to third_party/).
; mostly it's just the representation of history items that changes.
; I used instantiate as a shortcut to resolve variables, they have a procedure to find free variables.
; This is another solution that relies on instantiate: https://wizardbook.wordpress.com/2011/06/22/exercise-4-67/


; On second look, I do not understand the third party solution...
; This function looks like it's bugged, using `pattern` instead of `pat`:
;(define (freevars pat result)
;  (cond ((pair? pat)
;          (freevars (cdr pat)
;            (freevars (car pat) result)))
;    ((and (var? pat) (free-var? pat))
;      (cons pattern result))
;    (else result)))
; It always returns an empty list in my tests.

; That means history-freevars should *always be null*... and then 'still-unbound?' always return true.
; I changed the processed-query? code to comment out the call to `still-unbound?`:
;```
;(define (processed-query? query frame hist)
;  (if (empty-history? hist)
;    #f
;    (let* ((h (first-history hist))
;            (unify-match
;              (unify-match query
;                (history-query h)
;                frame)))
;      (or (and (not (eq? unify-match 'failed))
;            ;                 (still-unbound? (history-freevars h)
;            ;                                 unify-match)
;            )
;        (processed-query? query frame (rest-history hist))))))
;```
; and it behaved the same way! I just used it on a few examples but I feel like something is wrong here.
; Maybe it is sufficient if we can unify the patterns: the historical pattern can be unified with the result of the pattern and rule conclusion unification.
; does this mean it's a query we already processed?
; WELL I'M NOT SURE. HARD TO TELL. But probably yes. In the history we'll store the result of unification of pattern and rule conclusion.
; we might still have free variables in that. Ok.
; Now if the new query can unify with the historical one... I think it could just be a more specialised one?
; but I can't seem to convert that intuition into an example...
