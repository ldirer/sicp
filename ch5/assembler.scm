(load "ch5/ex5.8.scm")

(define (tagged-list? expr tag)
  (and
    (pair? expr)
    (eq? (car expr) tag)
    )
  )

(define (assemble controller-text machine)
  (extract-labels
    controller-text
    (lambda (insts labels)
      (update-insts! insts labels machine)
      insts
      )
    )
  )


; p521 in the paper book.
; > receive will be called with two values:
; > 1. a list of instruction data structures, each containing an instruction from `text`
; > 2. a table called `labels`, which associates each label from `text` with the position in the list `insts` that the label designates.
; Aaah the footnote explains: the receive procedure is a way to get 'extract-labels to return two values, without explicitly making a compound data structure to hold them.
; It's called a *continuation*. It's the next procedure to be invoked (like we did with backtracking). A little programming trick.
(define (extract-labels text receive)
  (if (null? text)
    (receive '() '())
    (extract-labels (cdr text)
      ; the way I understand it this will build a big stack of closures. One for each instruction.
      ; not very different from a recursive process I guess.
      ; We build the instruction list *from the end*. this is relevant to the make-label-entry call
      ; (we want it to use the list of instructions starting after the label).
      (lambda (insts labels)
        (let ((next-inst (car text)))
          (if (symbol? next-inst)
            (receive
              insts
              ; (cons (make-label-entry next-inst insts) labels)
              ; keeping exercise 5.8 extra programing-error handling
              (add-unique-label (make-label-entry next-inst insts) labels)
              )
            (receive (cons (make-instruction next-inst) insts) labels)
            )
          )
        )
      )
    )
  )



(define (update-insts! insts labels machine)
  (let (
         (pc (get-register machine 'pc))
         (flag (get-register machine 'flag))
         (stack (machine 'stack))
         (ops (machine 'operations))
         )
    ; augment the instruction objects inside the instructions list (with mutation)
    (for-each
      (lambda (inst)
        (set-instruction-execution-proc!
          inst
          (make-execution-procedure (instruction-text inst) labels machine pc flag stack ops)
          )
        )
      insts
      )
    insts
    )
  )

; instruction object
; text is kept around for debugging.
(define (make-instruction text) (cons text '()))
(define (instruction-text inst) (car inst))
(define (instruction-execution-proc inst) (cdr inst))
(define (set-instruction-execution-proc! inst proc) (set-cdr! inst proc))

; labels
(define (make-label-entry label-name insts) (cons label-name insts))

(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
    (if val
      (cdr val)
      (error "Undefined label -- ASSEMBLE" label-name)
      )
    )
  )


; the big dispatcher. Analyze-like in the chapter 4 interpreters discussion.
(define (make-execution-procedure inst labels machine pc flag stack ops)
  (cond
    ((assign-inst? inst) (make-assign inst machine labels ops pc))
    ((eq? (car inst) 'test) (make-test inst machine labels ops flag pc))
    ((eq? (car inst) 'branch) (make-branch inst machine labels flag pc))
    ((eq? (car inst) 'goto) (make-goto inst machine labels pc))
    ((eq? (car inst) 'save) (make-save inst machine stack pc))
    ((eq? (car inst) 'restore) (make-restore inst machine stack pc))
    ((eq? (car inst) 'perform) (make-perform inst machine labels ops pc))
    (else (error "Unknown instruction type -- ASSEMBLE" inst))
    )
  )

; added for ex5.10
(define (assign-inst? inst) (eq? (car inst) 'assign))

(define (make-assign inst machine labels operations pc)
  (let (
         (target (get-register machine (assign-reg-name inst)))
         (value-exp (assign-value-exp inst))
         )
    (let ((value-proc
            (if (operation-exp? value-exp)
              (make-operation-exp value-exp machine labels operations)
              (make-primitive-exp (car value-exp) machine labels)
              )
            ))
      (lambda ()
        (set-contents! target (value-proc))
        ; uh. I guess this is mutation without the ! in the proc name
        (advance-pc pc)
        )
      )
    )
  )

(define (assign-reg-name assign-instruction) (cadr assign-instruction))
(define (assign-value-exp assign-instruction) (cddr assign-instruction))


(define (advance-pc pc)
  ; Aha. I guess (cdr x) is still *just one number* (pointer).
  (set-contents! pc (cdr (get-contents pc)))
  )


(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
      (let ((condition-proc (make-operation-exp condition machine labels operations)))
        (lambda ()
          (set-contents! flag (condition-proc))
          (advance-pc pc))
        )
      (error "bad test instruction, an operation is required -- ASSEMBLE" inst)
      )
    )
  )

(define (test-condition test-instruction) (cdr test-instruction))


; branch
(define (make-branch inst machine labels flag pc)
  (let ((dest (branch-dest inst)))
    ; I changed the if with two branches into a if not, since it ends with an error.
    ; keeping the happy path left-aligned (go style).
    (if (not (label-exp? dest))
      (error "bad BRANCH instruction -- ASSEMBLE" inst)
      )
    (let ((insts (lookup-label labels (label-exp-label dest))))
      (lambda ()
        (if (get-contents flag)
          (set-contents! pc insts)
          (advance-pc pc)
          )
        )
      )
    )
  )

(define (branch-dest branch-instruction) (cadr branch-instruction))


; goto
(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst)))
    (cond
      ((label-exp? dest)
        (let ((insts (lookup-label labels (label-exp-label dest))))
          (lambda () (set-contents! pc insts))
          )
        )
      ((register-exp? dest)
        (let ((reg (get-register machine (register-exp-reg dest))))
          (lambda () (set-contents! pc (get-contents reg)))
          )
        )
      (else (error "Bad GOTO instruction -- ASSEMBLE" inst))
      )
    )
  )

(define (goto-dest goto-instruction) (cadr goto-instruction))


; stack instructions: save, restore
(define (make-save inst machine stack pc)
  (let ((reg (get-register machine (stack-inst-reg-name inst))))
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc)
      )
    )
  )

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine (stack-inst-reg-name inst))))
    (lambda ()
      (set-contents! reg (pop stack))
      (advance-pc pc)
      )
    )
  )

(define (stack-inst-reg-name inst) (cadr inst))

; perform
(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))

    (if (not (operation-exp? action))
      (error "Bad PERFORM instruction -- ASSEMBLE" inst)
      )

    (let ((action-proc (make-operation-exp action machine labels operations)))
      (lambda ()
        (action-proc)
        (advance-pc pc)
        )
      )
    )
  )

(define (perform-action inst) (cdr inst))


; primitive expressions
(define (make-primitive-exp exp machine labels)
  (cond
    ((constant-exp? exp)
      (let ((c (constant-exp-value exp)))
        (lambda () c)
        )
      )
    ((label-exp? exp)
      (let ((insts (lookup-label labels (label-exp-label exp))))
        (lambda () insts)
        )
      )
    ((register-exp? exp)
      (let ((r (get-register machine (register-exp-reg exp))))
        (lambda () (get-contents r))
        )
      )
    (else (error "Unknown expression type -- ASSEMBLE" exp))
    )
  )


; syntax procedures for expressions
(define (constant-exp? exp) (tagged-list? exp 'const))
(define (constant-exp-value exp) (cadr exp))

(define (label-exp? exp) (tagged-list? exp 'label))
(define (label-exp-label exp) (cadr exp))

(define (register-exp? exp) (tagged-list? exp 'reg))
(define (register-exp-reg exp) (cadr exp))



; operation exps
(define (make-operation-exp exp machine labels operations)
  (let (
         ; not sure why this is called 'prim'? primitive? why? It's an operation procedure.
         ; maybe it's in the sense of "primitive scheme procedure".
         (op (lookup-prim (operation-exp-op exp) operations))
         (aprocs
           (map
             (lambda (e)
               (if (not (or (constant-exp? e) (register-exp? e)))
                 (error "operations can only be used on constants or the contents of register -- ASSEMBLE" e)
                 )
               (make-primitive-exp e machine labels)
               )
             (operation-exp-operands exp)
             )
           )
         )
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs))
      )
    )
  )

(define (operation-exp? exp)
  (and (pair? exp) (tagged-list? (car exp) 'op))
  )

(define (operation-exp-op operation-exp) (cadr (car operation-exp)))
(define (operation-exp-operands operation-exp) (cdr operation-exp))


; lookup operation.
(define (lookup-prim symbol operations)
  (let ((val (assoc symbol operations)))
    (if val
      (cadr val)
      (error "Unknown operation -- ASSEMBLE" symbol))
    )
  )