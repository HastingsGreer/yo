#include "prelude.lisp"
#include "fastmath.lisp"

(defun ! (i) (if i (* i (! (- i 1))) 1))

(print (! 8))
