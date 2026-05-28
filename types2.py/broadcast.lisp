#include "prelude.lisp"

(defun printfirst (a b) (print a))

(defun sumsquare (a b) (add (mul a a) (mul b b)))

(defun circ (b) ((broadcast sumsquare) (sing b) b))

(defun main () (print (circ (range 10))))


