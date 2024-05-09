; 'solutions' online are not very satisfactory imho
;http://community.schemewiki.org/?sicp-ex-3.49
;https://github.com/ajkitson/sicp/blob/master/ch3/3.49.scm



;https://wizardbook.wordpress.com/2010/12/19/exercise-3-49/
; > The question hints that this mechanism can fail when we only realise what other resources we need access to once
; > we’ve acquired a lock – the most obvious example of this is database mutations.
; 'obvious'... good example though.


; I think the key is that a lock must first be taken, then we can figure out the other one. This means we can't reorder them.
; This pinpoints it: https://mk12.github.io/sicp/exercise/3/4.html#ex3.49
; we can't reorder them *unless* we leave a hole in our serialization, opening our code to the usual issues.

