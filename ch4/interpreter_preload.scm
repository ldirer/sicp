; save underlying apply before it gets overwritten

; I found essentially 0 information on interaction-environment.
; https://www.gnu.org/software/mit-scheme/documentation/stable/mit-scheme-ref.html#index-interaction_002denvironment

; this prevents a footgun where we load this module again *after* overwriting `apply`.
(if (environment-bound? (interaction-environment) 'apply-in-underlying-scheme)
  (error "this module has already been loaded. Please adjust 'load' calls to avoid reloading it, undesirable side effects might occur by reloading it.")
  )
(define apply-in-underlying-scheme apply)
