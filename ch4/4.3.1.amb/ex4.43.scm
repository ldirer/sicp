; meant to run with the ambiguous eval interpreter
(define (xor a b)
  (if a (not b) b)
  )

(define (map proc items)
  (if (null? items)
    '()
    (cons
      (proc (car items))
      (map proc (cdr items))
      )
    )
  )

(define (filter proc items)
  (cond ((null? items) '())
    ((proc (car items)) (cons (car items) (filter proc (cdr items))))
    (else (filter proc (cdr items)))
    )
  )


(define (distinct? items)
  (cond ((null? items) true)
    ((null? (cdr items)) true)
    ((member (car items) (cdr items)) false)
    (else (distinct? (cdr items)))
    )
  )

(define (yachts)
  (define (daughter obj) (car obj))
  (define (yacht obj) (cdr obj))
  (define (amb-pairs)
    (define pair (cons
                   (amb 'maryann 'gabrielle 'lorna 'rosalind 'melissa)
                   (amb 'maryann 'gabrielle 'lorna 'rosalind 'melissa)
                   ))
    (require (not (eq? (daughter pair) (yacht pair))))
    pair
    )

  (define moore (amb-pairs))
  (require (eq? (daughter moore) 'maryann))
  (require (eq? (yacht moore) 'lorna))
  ; optional: skip duplicates, faster. But tedious to write.
  ;  (require (not (eq? (daughter downing) (daughter mooore))))
  ;  (require (not (eq? (yacht downing) (yacht mooore)))

  ; Sir Barnacle Hood owns the Gabrielle
  ; Hall owns the rosalind
  ; "The Melissa owned by Downing, is named after Sir Barnacle's daughter".
  (let ((hood (amb-pairs)))
    (require (eq? (yacht hood) 'gabrielle))
    (let ((downing (amb-pairs)))
      (require (eq? (yacht downing) 'melissa))
      (require (eq? (daughter hood) 'melissa))
      (let ((hall (amb-pairs)))
        (require (eq? (yacht hall) 'rosalind))
        (let ((parker (amb-pairs)))
          (require (distinct? (map daughter (list moore downing hall hood parker))))
          (require (distinct? (map yacht (list moore downing hall hood parker))))
          ; Gabrielle's father owns the yacht named after Parker's daughter.
          (let ((filtered (filter (lambda (owner) (eq? (daughter owner) 'gabrielle)) (list moore downing hall hood parker))))
            (require (eq? (yacht (car filtered)) (daughter parker)))
            (list
              (list 'moore moore)
              (list 'downing downing)
              (list 'hall hall)
              (list 'hood hood)
              (list 'parker parker)
              )
            )
          )
        )
      )
    )
  )

(yachts)
;((moore (maryann . lorna)) (downing (lorna . melissa)) (hall (gabrielle . rosalind)) (hood (melissa . gabrielle)) (parker (rosalind . maryann)))
; Lorna's father is Colonel Downing.


; What happens if we are not told that Mary Ann's last name is Moore?
(define (yachts-moore-less)
  (define (daughter obj) (car obj))
  (define (yacht obj) (cdr obj))
  (define (amb-pairs)
    (define pair (cons
                   (amb 'maryann 'gabrielle 'lorna 'rosalind 'melissa)
                   (amb 'maryann 'gabrielle 'lorna 'rosalind 'melissa)
                   ))
    (require (not (eq? (daughter pair) (yacht pair))))
    pair
    )

  (define moore (amb-pairs))
;  (require (eq? (daughter moore) 'maryann))
  (require (eq? (yacht moore) 'lorna))
  ; optional: skip duplicates, faster. But tedious to write.
  ;  (require (not (eq? (daughter downing) (daughter mooore))))
  ;  (require (not (eq? (yacht downing) (yacht mooore)))

  ; Sir Barnacle Hood owns the Gabrielle
  ; Hall owns the rosalind
  ; "The Melissa owned by Downing, is named after Sir Barnacle's daughter".
  (let ((hood (amb-pairs)))
    (require (eq? (yacht hood) 'gabrielle))
    (let ((downing (amb-pairs)))
      (require (eq? (yacht downing) 'melissa))
      (require (eq? (daughter hood) 'melissa))
      (let ((hall (amb-pairs)))
        (require (eq? (yacht hall) 'rosalind))
        (let ((parker (amb-pairs)))
          (require (distinct? (map daughter (list moore downing hall hood parker))))
          (require (distinct? (map yacht (list moore downing hall hood parker))))
          ; Gabrielle's father owns the yacht named after Parker's daughter.
          (let ((filtered (filter (lambda (owner) (eq? (daughter owner) 'gabrielle)) (list moore downing hall hood parker))))
            (require (eq? (yacht (car filtered)) (daughter parker)))
            (list
              (list 'moore moore)
              (list 'downing downing)
              (list 'hall hall)
              (list 'hood hood)
              (list 'parker parker)
              )
            )
          )
        )
      )
    )
  )

(yachts-moore-less)
try-again
try-again
try-again

; two solutions (the first one is the same as before):
;((moore (maryann . lorna)) (downing (lorna . melissa)) (hall (gabrielle . rosalind)) (hood (melissa . gabrielle)) (parker (rosalind . maryann)))
;((moore (gabrielle . lorna)) (downing (rosalind . melissa)) (hall (maryann . rosalind)) (hood (melissa . gabrielle)) (parker (lorna . maryann)))

