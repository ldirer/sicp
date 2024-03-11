(define (make-mobile left right)
  (list left right))


(define (make-branch length structure)
  (list length structure)
  )


(define (left-branch mobile)
  (car mobile)
  )
(define (right-branch mobile)
  (cadr mobile)
  )


(define (branch-length branch) (car branch))
(define (branch-structure branch) (cadr branch))


(define (total-weight mobile)
  (+ (total-branch-weight (left-branch mobile)) (total-branch-weight (right-branch mobile))
    )
  )


(define (total-branch-weight branch)
  (let ((structure (branch-structure branch)))
    (if (pair? structure)
      (total-weight structure)
      structure
      )
    )
  )



(define a (make-mobile (make-branch 1 4) (make-branch 1 3)))
(total-weight a)
; expected: 7


(define simple-balanced (make-mobile (make-branch 1 2) (make-branch 2 1)))


(define b (make-mobile (make-branch 1 a) (make-branch 1 a)))
(define c (make-mobile (make-branch 2 simple-balanced) (make-branch 2 simple-balanced)))

(total-weight c)
; expected: 6

(define (torque branch)
  (* (branch-length branch) (total-branch-weight branch))
  )

(torque (make-branch 1 100))
; expected: 100

(define (balanced? mobile)
  ; base case includes a single number (weight)
  (if (not (pair? mobile))
    true
    (let ((left (left-branch mobile))
         (right (right-branch mobile)))
    (and (= (torque left) (torque right)) (balanced? (branch-structure left)))
    )
    )

  )

(balanced? a)
; expected: false

;(trace balanced?)

(balanced? b)
; expected: false


(balanced? simple-balanced)
; expected: true

(balanced? c)
; expected: true



; d. Change representation of mobile/branch.

(define (make-mobile left right)
  (cons left right)
  )
(define (make-branch length structure)
  (cons length structure)
  )

; need to rewrite selectors
(define (left-branch mobile)
  (car mobile)
  )
(define (right-branch mobile)
  (cdr mobile)
  )


(define (branch-length branch) (car branch))
(define (branch-structure branch) (cdr branch))



(define a (make-mobile (make-branch 1 4) (make-branch 1 3)))
(total-weight a)
; expected: 7
(define simple-balanced (make-mobile (make-branch 1 2) (make-branch 2 1)))
(define b (make-mobile (make-branch 1 a) (make-branch 1 a)))
(define c (make-mobile (make-branch 2 simple-balanced) (make-branch 2 simple-balanced)))

(balanced? a)
; expected: false

;(trace balanced?)

(balanced? b)
; expected: false


(balanced? simple-balanced)
; expected: true

(balanced? c)
; expected: true
