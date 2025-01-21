(load "testing.scm")
(load "ch5/machine.scm")
(load "ch5/ex5.19.scm")
(load "ch5/garbage_collector.scm")


;  (const broken-heart)  --> how does the assembler deal with that?
; Since it just uses whatever `const` is passed as a scheme value, we can just define the constant here!
; --> incorrect. We do not `eval` the scheme value passed to const. So it stays a **symbol**.
(define (broken-heart? val) (eq? val 'broken-heart))

(define (print . args)
  (newline)
  (for-each (lambda (arg)
              (display arg)
              (display " ")
              )
    args)
  )


; I had some difficulty getting this to run. Ramblings:

; - We need some data to test the garbage collector on.
; So I added registers x and y. How do we put a list in register x?
; We could do (set-register-contents 'x (list 1 2 3)) but that would not use `the-cars` and `the-cdrs`... Not helpful.
; I used the cons operations in machine code, a little tedious (extra controller code I added).
;
; - How do we make it so that x is a list? when we do (assign x (reg free)) we just store the value in free!
; Do we need the typed-pointers thing? It's mentioned but not implemented by the book.
; I think the typed-pointers means we would store all list pointers as 100..000, 100..001, 100..010, 100..011.
; Saving maybe 4 bits for the type of the pointer.
; In the mean time maybe we can cheat a bit and add a 'get-register-contents-as-list' (or just 'interpret-as-list-pointer') proc.
; easy to write at least (make the-cars and the-cdrs globals so that proc can access them too).
; --> I did that, it was a bit broken ('intepret-as-list-pointer' effectively hardcoded the level of list nesting) and then there was `pointer-to-pair?` that I had no solution for, so the garbage collector did not run correctly.
; See below, some version of typed pointers is required. We can't tell if x stores a number or a list otherwise.
;
; - The book mentions pointer-to-pair? isn't the same as pair? - many objects are 'pairs' for the purpose of garbage collections (procedures for instance).
; The book goes on to say that for simulation purposes, pair? is fine. But that means we would store lists in registers.
; While it's fine to `set-register-contents! 'x (cons 'list-pointer 2)`, I'm not sure how we make it work with things like `assign x (reg free)` without changing the assembler code.
; Anyway, I ended up using a hacky implementation of typed pointers. Integers below a certain threshold are pointers, the rest are regular integers.
;
; - The book mentions the `root` register can be made to point to a 'pre-allocated list of all relevant registers', so it's really "the root of all useful data".
; I had to do this as well.
; - I added a bit that runs after garbage collection to set the correct values inside the x and y registers.
; I think we could also have kept the old values and followed the broken hearts instead.

;;; hacky implementation of typed pointers.
(define (pointer-to-pair? x) (and (integer? x) (< x 10000)))


(define test-controller
  '(wrapper-start
     (assign free (const 0))

     ; trying to translate (list 10001 10002 10003). Not so easy :)
     (perform (op vector-set!) (reg the-cars) (reg free) (const 10003))
     (perform (op vector-set!) (reg the-cdrs) (reg free) (const e0))
     (assign x (reg free))
     (assign free (op +) (reg free) (const 1))

     (perform (op vector-set!) (reg the-cars) (reg free) (const 10002))
     (perform (op vector-set!) (reg the-cdrs) (reg free) (reg x))
     (assign x (reg free))
     (assign free (op +) (reg free) (const 1))

     (perform (op vector-set!) (reg the-cars) (reg free) (const 10001))
     (perform (op vector-set!) (reg the-cdrs) (reg free) (reg x))
     (assign x (reg free))
     (assign free (op +) (reg free) (const 1))

     ; simulate memory that was used but nothing points to it anymore
     ; the garbage collector should produce the same result with or without this line. It helps observe the compaction aspect of garbage collection.
     (assign free (op +) (reg free) (const 10))

     ;     (assign y (const 10099))
     ; y: (list x 10099)
     (perform (op vector-set!) (reg the-cars) (reg free) (const 10099))
     (perform (op vector-set!) (reg the-cdrs) (reg free) (const e0))
     (assign y (reg free))
     (assign free (op +) (reg free) (const 1))

     (perform (op vector-set!) (reg the-cars) (reg free) (reg x))
     (perform (op vector-set!) (reg the-cdrs) (reg free) (reg y))
     (assign y (reg free))
     (assign free (op +) (reg free) (const 1))


     ; set the root pointer. Crucial to bootstrap the garbage collection.
     ; the text mentions root should point to a 'pre-allocated list'. I think the 'pre-allocated' part just means it should not interfere with a full memory.
     ; here we know we have space so it's fine to increment free.
     ; root points to (x y)
     (perform (op vector-set!) (reg the-cars) (reg free) (reg y))
     (perform (op vector-set!) (reg the-cdrs) (reg free) (const e0))
     (assign root (reg free))
     (assign free (op +) (reg free) (const 1))

     (perform (op vector-set!) (reg the-cars) (reg free) (reg x))
     (perform (op vector-set!) (reg the-cdrs) (reg free) (reg root))
     (assign root (reg free))
     (assign free (op +) (reg free) (const 1))

     ))

(define unwrap-root-into-registers-controller
  '(
     (assign x (op vector-ref) (reg the-cars) (reg root))
     ; y: (cadr root)
     (assign y (op vector-ref) (reg the-cdrs) (reg root))
     (assign y (op vector-ref) (reg the-cars) (reg y))
     ))

(define machine (make-machine
                  '(
                     ; non-garbage-collection registers
                     x
                     y
                     root  ; ? might need to do something more about this
                     temp
                     old
                     new
                     oldcr
                     the-cars
                     the-cdrs
                     new-cars
                     new-cdrs
                     free
                     scan
                     relocate-continue
                     )
                  (list
                    (list 'print print)
                    (list 'broken-heart? broken-heart?)
                    (list 'vector-ref vector-ref)
                    (list 'vector-set! vector-set!)
                    ; the book mentions pointer-to-pair? isn't the same as pair? - many objects are 'pairs' for the purpose of garbage collections.
                    ; procedures for instance. But they wouldn't be 'pairs' according to pair?.
                    ; anyway, for simulation pair? is fine.
                    ;                    (list 'pointer-to-pair? pair?)
                    (list 'pointer-to-pair? pointer-to-pair?)
                    (list '= =)
                    (list '+ +)
                    )
                  (append
                    test-controller
                    gc-controller
                    unwrap-root-into-registers-controller
                    )
                  )
  )



(define the-cars (make-vector 1000))
(define the-cdrs (make-vector 1000))
(define new-cars (make-vector 1000))
(define new-cdrs (make-vector 1000))

(define (get-register-contents-as-list reg-name)
  (interpret-as-pointer (get-register-contents machine reg-name))
  )
;;; This is a bit lame because it only converts *one level* of lists.
;;; I'm not sure how to achieve the general behavior that works for a list with several levels of nesting, numbers, strings...
;;; I think it would require an implementation for typed pointers.
(define (interpret-as-pointer value)
  (cond
    ((eq? value 'e0) (list))
    ((pointer-to-pair? value)
      (cons
        (interpret-as-pointer (vector-ref (get-register-contents machine 'the-cars) value))
        (interpret-as-pointer (vector-ref (get-register-contents machine 'the-cdrs) value))
        ))
    (else value)
    )
  )

(define (display-memory)
  (newline)
  (display "working memory before garbage collection:")
  (newline)
  (display the-cars)
  (newline)
  (display the-cdrs)

  (newline)
  (display "free memory before garbage collection:")
  (newline)
  (display new-cars)
  (newline)
  (display new-cdrs)
  )
(define (display-register-state machine)
  (newline)

  (for-each
    (lambda (reg-name)
      (display " ---------- ")
      (display reg-name)
      (display " | ")
      (display-reg-value (get-register-contents machine reg-name))
      )
    (list 'x 'y)
    )
  )


(define (display-reg-value x)
  (if (pointer-to-pair? x)
    (display "p")
    (display "n")
    )
  (display x)
  )


(set-register-contents! machine 'the-cars the-cars)
(set-register-contents! machine 'the-cdrs the-cdrs)
(set-register-contents! machine 'new-cars new-cars)
(set-register-contents! machine 'new-cdrs new-cdrs)

; I want to test fetching data *before* garbage collection and then after.
; Using breakpoints lets us interrupt the machine after memory has been initialized and before garbage collection.
(set-breakpoint machine 'begin-garbage-collection 1)

(start machine)

(get-register-contents machine 'root)
(get-register-contents-as-list 'root)
(check-equal "sanity check contents of x before garbage collection" (get-register-contents-as-list 'x) (list 10001 10002 10003))
(check-equal "can retrieve contents of y after garbage collection" (get-register-contents-as-list 'y) (list (list 10001 10002 10003) 10099))


(begin
  (newline)
  (display "BEFORE GARBAGE COLLECTION")
  (display-memory)
  )

(proceed-machine machine)

(display-register-state machine)

(check-equal "can retrieve contents of x after garbage collection" (get-register-contents-as-list 'x) (list 10001 10002 10003))
(check-equal "can retrieve contents of y after garbage collection" (get-register-contents-as-list 'y) (list (list 10001 10002 10003) 10099))

(check-equal "garbage collector swapped memories" (get-register-contents machine 'the-cars) new-cars)
(check-equal "garbage collector swapped memories" (get-register-contents machine 'the-cdrs) new-cdrs)

(begin
  (newline)
  (display "AFTER GARBAGE COLLECTION")
  (display-memory)
  )
