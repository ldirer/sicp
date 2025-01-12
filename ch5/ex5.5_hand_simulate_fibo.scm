; I tried to rewrite it without looking at the text.
; This is not easy!
(define (fib n)
  (if (< n 2)
    n
    (+ (fib (- n 1)) (fib (- n 2)))
    )
  )

(controller
  (assign continue (label fib-done))

  fib-loop
  (test (op <) (reg n) (const 2))
  (branch (label immediate-answer))
  ; recursive main course

  (save continue)
  (assign continue (label after-fib-n-1))
  (save n)
  (assign n (op -) (reg n) (const 1))
  (goto (label fib-loop))

  after-fib-n-1
  (restore n)
  (restore continue)

  (assign n (op -) (reg n) (const 2))
  ; always save before assigning to continue
  (save continue)
  (assign continue (label after-fib-n-2))

  (save val)

  (goto (label fib-loop))

  after-fib-n-2
  ; use n as a temporary register. We'll restore it later anyway.
  ; store the value of (fib (- n 1))
  (assign n (reg val))
  (restore val)
  (restore continue)
  (assign val (op +) (reg val) (reg n))
  (goto (reg continue))

  immediate-answer
  (assign val (reg n))
  (goto (reg continue))
  fib-done
  )


; hand-simulation of (fib 3).
; n=3
; c<-fib-done
; -- loop, n=3
; s: (fib-done)
; c<-after-fib-n-1
; s: (fib-done 3)
; n<-n-1 = 2
; -- loop
; s: (fib-done 3 after-fib-n-1)
; c<-after-fib-n-1
; s: (fib-done 3 after-fib-n-1 2)
; n<-n-1 = 1
; -- loop
; test says branch immediate answer
; val<-n = 1
; goto c=after-fib-n-1
; -- after-fib-n-1
; restore n and continue
; n<-2
; c<-after-fib-n-1
; s: (fib-done 3)
; n<-n-2=0
; save continue
; s: (fib-done 3 after-fib-n-1)
; At this stage I'm like: "didn't we just restore? Why restore to save immediately?": this is exercise 5.6.
; c<-after-fib-n-2
; save val
; s: (fib-done 3 after-fib-n-1 1)
; goto fib-loop
; -- loop
; branch immediate answer
; val<-n = 0
; goto c=after-fib-n-2
; -- after-fib-n-2
; n<-val=0
; restore val and continue
; val<-1
; c<-after-fib-n-1
; s: (fib-done 3)
; val<-val+n=1
; goto continue
; -- after-fib-n-1
; restore n and continue
; n<-3
; c<-fib-done
; s: ()
; n<-n-2=1
; save continue
; s: (fib-done)
; c<-after-fib-n-2
; save val
; s: (fib-done 1)
; goto fib-loop
; -- loop
; branch immediate answer
; val<-n=1
; goto continue
; -- after-fib-n-2
; n<-val=1
; restore val and continue
; val<-1
; continue<-fib-done
; val<-val+n=1+1=2
; goto continue
; fib-done
; \o/. PHEW.