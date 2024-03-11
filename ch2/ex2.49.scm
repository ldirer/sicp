(load "ch2/ex2.48.scm")
(load "ch2/ex2.47.scm")
;Use segments->painter to deﬁne the following primitive painters:
;a. the painter that draws the outline of the designated frame.
;b. the painter that draws an “X” by connecting opposite corners of the frame.
;c. the painter that draws a diamond shape by connecting the midpoints of the sides of the frame.
;d. the wave painter.

(define (outline-painter frame)
  (segments->painter (list
                       (make-segment (make-vect 0 .0 0 .0) (make-vect 1 .0 0 .0))
                       (make-segment (make-vect 1 .0 0 .0) (make-vect 1 .0 1 .0))
                       (make-segment (make-vect 1 .0 1 .0) (make-vect 0 .0 1 .0))
                       (make-segment (make-vect 0 .0 1 .0) (make-vect 0 .0 0 .0))
                       )
    )
  )

(define (x-painter frame)
  (segments->painter (list
                       (make-segment (make-vect 0 .0 0 .0) (make-vect 1 .0 1 .0))
                       (make-segment (make-vect 0 .0 1 .0) (make-vect 1 .0 0 .0))
                       )
    )
  )

(define (diamond-painter frame)
  (segments->painter (list
                       (make-segment (make-vect 0 0 .5) (make-vect 0 .5 1))
                       (make-segment (make-vect 0 .5 1) (make-vect 1 0 .5))
                       (make-segment (make-vect 1 0 .5) (make-vect 0 .5 0))
                       (make-segment (make-vect 0 .5 0) (make-vect 0 0 .5))
                       )
    )
  )

(define (wave-painter frame)
  (segments->painter (list
                       ; skipping ! Tedious.
                       ))
  )
