; code from section 4.4.4.5 ~p480 paper.
; ambiguous evaluator version: uses lists instead of streams to store data. I don't think this matters much.
; Then the interface with the rest of the code uses amb values.

(define THE-ASSERTIONS (list))

(define (fetch-assertions pattern frame)
  (if (use-index? pattern)
    (an-element-of (get-indexed-assertions pattern))
    (an-element-of (get-all-assertions))
    )
  )

(define (get-all-assertions) THE-ASSERTIONS)

(define (get-indexed-assertions pattern)
  (get-list (index-key-of pattern) 'assertion-list))

(define (get-list key1 key2)
  (let ((s (get key1 key2)))
    (if s s (list))
    )
  )

; when fetching rules that might match a pattern whose `car` is a constant symbol we want to
; fetch all rules whose conclusions start with a variable as well as
; those whose conclusions have the same `car` as the pattern.
(define THE-RULES (list))
(define (fetch-rules pattern frame)
  (if (use-index? pattern)
    (an-element-of (get-indexed-rules pattern))
    (an-element-of (get-all-rules))
    )
  )

(define (get-all-rules) THE-RULES)
(define (get-indexed-rules pattern)
  (append
    (get-list (index-key-of pattern) 'rule-list)
    (get-list '? 'rule-list)
    )
  )


(define (add-rule-or-assertion! assertion)
  (if (rule? assertion)
    (add-rule! assertion)
    (add-assertion! assertion)))


(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (permanent-set! THE-ASSERTIONS (cons assertion THE-ASSERTIONS))
  'ok
  )

(define (add-rule! rule)
  (store-rule-in-index rule)
  (permanent-set! THE-RULES (cons rule THE-RULES))
  'ok
  )

(define (store-assertion-in-index assertion)
  (if (indexable? assertion)
    (let ((key (index-key-of assertion)))
      (let ((current-assertion-list (get-list key 'assertion-list)))
        (put
          key
          'assertion-list
          (cons assertion current-assertion-list)
          )
        )
      )
    )
  )

(define (store-rule-in-index rule)
  (let ((pattern (conclusion rule)))
    (if (indexable? pattern)
      (let ((key (index-key-of pattern)))
        (let ((current-rule-list (get-list key 'rule-list)))
          (put
            key
            'rule-list
            (cons rule current-rule-list)
            )
          )
        )
      )
    )
  )


(define (indexable? pat)
  (or
    (constant-symbol? (car pat))
    (var? (car pat))
    )
  )

(define (index-key-of pat)
  (let ((key (car pat)))
    (if (var? key) '? key)
    )
  )

(define (use-index? pat)
  (constant-symbol? (car pat))
  )