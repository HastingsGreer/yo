#include "prelude.lisp"

(backend asm Instr and)
(header (and I64 I64) I64)
(defun render (x) (if x " " "#"))
(print 
  ((. render) ((. and) (range 32) (list (range 32)))))
