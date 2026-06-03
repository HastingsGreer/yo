#include "prelude.lisp"

(defun ((λx. BODY) X) (x) BODY)
(defun ((λy. BODY) Y) (Y) BODY)

// (defun main () (print ((map (λx. (+ x x))) (range 20))))

(defun ((λx. λy. BODY) X Y) (x y) BODY)
(print ((λx. λy. (+ x y)) 4 3))
