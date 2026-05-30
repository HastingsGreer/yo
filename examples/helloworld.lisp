#include "prelude.lisp"

(defun main () (do 
		 ((map print_) ((reduce cat) (triple 
					     (quad 104 101 108 108) 
					     (quad 111 32 119 111)
					     (quad 114 108 100 10))
					   (nil 0)))
		 0
		 ))
(defun (cat_impl (List T) (List T)) (a b) (if a (cat_impl (cdr a) (cons (car a) b)) b))
(defun (cat (List T) (List T)) (a b) (cat_impl (reverse a) b))
(defun ((reduce F) (List T) O ) (l o) (if l
				       (F (car l) ((reduce F) (cdr l) o))
				       o
				       ))

