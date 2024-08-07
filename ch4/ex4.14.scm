;;; M-Eval input:
(define (map proc a-list) (if (null? a-list) nil (cons (apply proc (cons (car a-list) nil)) (map proc (cdr a-list)))))
;;;; M-Eval value:
;ok

;;; M-Eval input:
(define alist (cons (cons 1 1) (cons (cons 2 2) nil)))
;;;; M-Eval value:
;ok

;;; M-Eval input:
(map car alist)
;;;; M-Eval value:
;(1 2)


; Louis Reasoner's version does not work because the builtin `map` expects Scheme
; procedures. Instead it receives our custom compound procedure (or primitive procedures) objects.
; It tries to call them. Complains such objects (lists!) are not applicable.


; Verifying this:

;;; M-Eval input:
(define alist (cons (cons 1 1) (cons (cons 2 2) nil)))

;;;; M-Eval value:
;ok

;;; M-Eval input:
(map car alist)
;The object (primitive #[compiled-procedure 12 ("list" #x1) #x1c #xe2d824]) is not applicable.