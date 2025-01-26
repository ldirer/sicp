; on top of this, I added a case to the eval-dispatch controller and a couple new primitive operations.
(define ev-cond-controller
  '(
     ev-cond
     (assign exp (op cond->if) (reg exp))
     (goto (label eval-dispatch))
     )
  )


(define ev-let-controller
  '(
     ev-let
     (perform (op debug-print) (const "in let controller, exp=") (reg exp))
     (assign exp (op let->combination) (reg exp))
     (goto (label eval-dispatch))
     )
  )