; > Design a register machine to compute factorials using the iterative algorithm specified by the following procedure.
; > Draw data-path and controller diagrams for this machine.


(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
      product
      (iter (* counter product) (+ counter 1))))
  (iter 1 1)
  )


; draft of what the controller code might look like in my current understanding:
; label 'factorial-start
; product <- 1
; counter <- 1
; test > counter n
; label 'done
; product <- counter * product
; counter <- counter + 1
; go-to 'factorial-start

; I'm not sure if 'product<-1' and 'counter<-1' are 'buttons'. Probably.
; if I don't have a name for them I can't really write the controller specification.

(data-paths
  (registers
    ((name n)
      (buttons)
      )
    ((name p)
      (buttons
        ((name (p<-c*p)) (source (operation *)))
        ((name (p<-1)) (source (constant 1)))
        )
      )
    ((name c)
      (buttons
        ((name (c<-c+1)) (source (operation +)))
        ((name (c<-1)) (source (constant 1)))
        )
      )
    )

  (operations
    ((name *)
      (inputs (register c) (register p))
      )
    ((name +)
      (inputs (register c) (constant 1))
      )
    ((name >)
      (inputs (register c) (register n)))
    )
  )


(controller
  (p<-1)                              ; button push
  (c<-1)                              ; button push
  test-counter                        ; label
  (test >)                            ; test
  (branch (label factorial-done))     ; conditional branch
  (p<-c*p)                            ; button push
  (c<-c+1)                            ; button push
  (goto (label test-counter))         ; unconditional branch
  factorial-done                      ; label
  )

