My solutions to Structure and Interpretation of Computer Programs (SICP) exercises.  

There are certainly mistakes in there. I did not do all the exercises. Notably 5.51, 5.52, and 4.79 are missing.

Resources I recommend for exercise solutions:

- https://eli.thegreenplace.net/
- https://www.inchmeal.io/sicp/review.html
 
There are more but those are the best write-ups I've seen that go through the whole book.

I wrote on my experience with SICP [here](https://ldirer.com/blog/posts/sicp-review).

## Tools

I used a non-sophisticated setup with MIT/GNU Scheme 12.1, `rlwrap scheme`, and a shortcut to run `scheme < [current_file]` from my editor.

A trick I used in parts of chapters 4 and 5 to test my code is to run it with input redirection:

    scheme < my_file.scm

and mix lines meant to be executed by Scheme and lines meant to run in a custom interpreter.

Scheme-atically:

    ;; this line will be executed by Scheme
    (launch-interpreter-read-eval-print-loop)
    ;; will run in the custom interpreter repl loop just launched
    (list 1 2 3)

This felt like a terrible hack but was very useful to avoid copy-pasting things into a repl over and over.  
Sometimes I even added:

    (debug)
    H

directly in the file after a statement that crashed, to get some semblance of stacktrace.