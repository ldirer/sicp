; > With the simulator as written, what will the contents of register `a` be when control reaches `there`?
;start
;(goto (label here))
;here
;(assign a (const 3))
;(goto (label there))
;here
;(assign a (const 4))
;(goto (label there))
;there


; I think with the simulator as written, the labels table will look like:
; ((start ...) (here ...) (here ...) (there ...))
; because we build it starting from the last instruction and `cons`-ing as we go.

; That means the first here clobbers the second one, and register a will hold 3 when we get `there`.


; extra 'labels' code:
(define (add-unique-label label labels)
  (define label-name (car label))
  (let ((val (assoc label-name labels)))
    (if val
      (error "label name already exists -- ADD-LABEL" label-name)
      (cons label labels)
      )
    )
  )

