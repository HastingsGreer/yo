#include "prelude.lisp"

(defun ((λx. BODY) X) (x) BODY)

(defun main () (print ((map (λx. (add x x))) (range 20))))
