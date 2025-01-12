
; recursive factorial machine
(controller
  (assign continue (label fact-done))
  fact-loop

  (test (op =) (reg n) (const 0))
  (branch fact-base-case)

  ; prepare for recursive call
  (save continue)
  (save n)
  (assign n (op -) (reg n) (const 1))
  (assign continue (label after-fact))
  (goto (label fact-loop))

  after-fact
  ; undo the 'save' that we did in *our* level of recursion. Order matters! we are sharing a stack here.
  (restore n)
  (restore continue)
  (assign val (op *) (reg n) (reg val))
  (goto (reg continue))

  fact-base-case
  ; note there's no 'restore continue' here.
  (assign val (const 1))
  (goto (reg continue))
  fact-done
  )


; hand-simulate (fact 3)

; reg n = 3
; stack: s:(). continue=c
; -- loop, rn = 3
; c: fact-done
; s: (fact-done 3)
; n<-2
; continue<-after-fact
; -- loop
; s: (fact-done 3 after-fact 2)
; n<-1
; continue<-after-fact
; -- loop
; s: (fact-done 3 after-fact 2 after-fact 1)
; n<-0
; continue<-after-fact
; -- loop
; -- test says base case
; val<-1
; goto continue = goto after-fact
; -- after-fact
; restore n and continue:
; n<-1
; continue<-after-fact
; s: (fact-done 3 after-fact 2)
; val<-val*n = 1
; goto continue = goto after-fact
; -- after-fact again
; restore n and continue:
; n<-2
; continue<-after-fact
; s: (fact-done 3)
; val<-val*n = 2
; goto continue = goto after-fact
; -- after-fact again
; restore n and continue:
; n<-3
; continue<-fact-done
; s: ()
; val<-val*n = 6
; goto continue = goto fact-done
; THE END.
