(load "ch4/4.4.logic/data_jobs.scm")


(sum ?amount (and (job ?x (computer programmer))
               (salary ?x ?amount)))


(accumulation-function <variable> <query pattern>)

; Ben just realized that there might be duplicates in the results of matching <query pattern>, causing his accumulation to count things multiple times.
; A way to salvage this is to introduce a way of deduplicating.
(accumulation-function <record-id-proc> <variable> <query pattern>)

; With a procedure returning a record identifier, the accumulation function could ignore duplicates (with a flexible definition of that, depending on the use case).
