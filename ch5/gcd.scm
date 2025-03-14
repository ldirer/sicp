; page 497 (paper version), section 5.1.1 around figure 5.3.


(data-paths
  (registers
    ((name a)
      (buttons ((name a<-b) (source (register b)))))
    ((name b)
      (buttons ((name b<-t) (source (register t)))))
    ((name t)
      (buttons ((name t<-r) (source (operation rem))))
      )

    )

  (operations
    ((name rem)
      (inputs (register a) (register b))
      )
    ((name =)
      (inputs (register b) (constant 0))
      )
    )
  )

(controller
  test-b
    (test (op =) (reg b) (const 0))
    (branch (label gcd-done))
    (assign t (op rem) (reg a) (reg b))
    (assign a (reg b))
    (assign b (reg t))
    (goto (label test-b))
  gcd-done
  )