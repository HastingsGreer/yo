#include "prelude.lisp"
#include "fastmath.lisp"

#define size 512

(backend asm Instr and)

(header (and I64 I64) I64)
(do
  (print "P3\n")
  (print size)
  (print size)
  (print "\n255\n")
  ((. print) 
   ((. *) 
    (list (list (list 120 140 100)))
     ((. =) 
      0 
      ((. and) (range size) (list (range size)))))))
