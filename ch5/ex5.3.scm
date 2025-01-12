; > Design a machine to compute square roots using Newton's method, as described in section 1.1.7.

(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess) (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
      guess
      (sqrt-iter (improve guess)))
    )
  (sqrt-iter 1.0)
  )




; > Begin by assuming that good-enough? and improve operations are available as primitives.
; > Then show how to expand these in terms of arithmetic operations.
; > Describe each version of the sqrt machine desgin by drawing
; > a data-path diagram and writing a controller definition in the register-machine language.

(data-paths
  (registers
    ((name x)
      (buttons)
      )
    ((name g)
      (buttons
        ((name g<-next-g) (source (operation improve)))
        ((name g<-init) (source (constant 1.0)))
        )
      )
    )

  (operations
    ((name improve) (inputs (register g) (register x)))
    ((name good-enough?) (inputs (register g) (register x)))
    )
  )


; in register-machine language
(controller
  (assign g (const 1.0))
  loop-start
  (test (op good-enough?) (reg g) (reg x))
  (branch (label sqrt-done))
  (assign g (op improve) (reg g) (reg x))
  (goto (label loop-start))
  sqrt-done
  )




; to expand good-enough? we need a temporary register to store the computation value ((square guess), then (- (square guess x)), then...
; I assumed 'abs' was a primitive. It probably isn't.
(data-paths
  (registers
    ((name x)
      (buttons)
      )
    ((name t)
      (buttons
        ; buttons for good-enough?
        ((name t<-g-square) (source (operation *)))
        ((name t<-t-x) (source (operation -)))
        ((name t<-abs-t) (source (operation abs)))
        ; buttons for improve. we can reuse the same register.
        ((name t<-x/g (source (operation /))))
        ((name t<-t+g (source (operation +))))
        )
      )
    ((name g)
      (buttons
        ((name g<-t/2 (source (operation halve-t))))
        ((name g<-init) (source (constant 1.0)))
        )
      )
    )

  (operations
    ((name abs) (inputs (register t)))
    ((name *) (inputs (register g) (register g)))
    ((name <) (inputs (register t) (constant 0.001)))
    ((name /) (inputs (register x) (register g)))
    ((name +) (inputs (register t) (register g)))
    ((name halve-t) (inputs (register t) (constant 2)))
    )
  )

; in register-machine language, expanded version
; There's a discrepancy with the data-paths spec, this uses '(op /) (reg t) (const 2)' and not '(op halve-t)'.
; I think it's halve-t that should be '/' somehow taking different inputs in the data-paths spec. Not sure what the syntax should look like.
; Asked Chat, it said we could name `halve-t` `/` in the data-paths spec. Leaving it ambiguous but it's fine.
; Not a big deal.
(controller
  (assign g (const 1.0))

  loop-start
  ; good-enough code
  (assign t (op *) (reg g) (reg g))
  (assign t (op -) (reg t) (reg x))
  (assign t (op abs) (reg t))
  ; test
  (test (op <) (reg t) (const 0.001))
  (branch (label sqrt-done))
  ; improve code
  (assign t (op /) (reg x) (reg g))
  (assign t (op +) (reg t) (reg g))
  (assign g (op /) (reg t) (const 2))
  ; loop
  (goto (label loop-start))
  sqrt-done
  )
