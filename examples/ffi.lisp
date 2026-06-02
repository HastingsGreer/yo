#include "prelude.lisp"

(header (getfour I64) I64)
(backend asm Linked getfour 1)

(defun main () (print (getfour 3)))
