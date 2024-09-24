; works on a MIT Scheme environment, like system-global-environment or user-initial-environment
; will only print bindings that contain filter-string
; this could be turned into a filter function for more flexibility (but a more complicated api)...
(define (pprint-environment-bindings env filter-string)
  (define (display-binding binding)
    ; (name value) or just (name) if unassigned
    (display binding)
    (newline)
    )
  (define (name binding)
    (symbol->string (car binding))
    )

  (define bindings (filter
                     (lambda (b) (substring? (string-downcase filter-string) (string-downcase (name b))))
                     (environment-bindings env)))

  ;https://www.gnu.org/software/mit-scheme/documentation/stable/mit-scheme-ref/Miscellaneous-List-Operations.html
  ; sort sequence procedure [key]
  ; in our example: key=car because we sort by the first element. Then it's a sort on... symbols? strings?
  (map display-binding (sort bindings string-ci<? name))
  'done
  )
;(pprint-environment-bindings system-global-environment "cond")
