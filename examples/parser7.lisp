#include "prelude.lisp"
#include "closure.lisp"

(defun (combine Char (List String)) (char lexed) 
  (if (|| (= char " ") (= char "\n"))
    (cons "" lexed)
    (if (= char "(")
        (cons "" (cons "(" lexed))
	(if (= char ")")
	   (cons "" (cons ")" lexed))
           (cons (cons char (car lexed))
		 (cdr lexed))))))

(defun lex (string) ((filter (\ X . X))
		     ((reduce combine) (:chars string) (list ""))))

ENUM2(Tree,
       Sexpr, (List Tree), 
       Leaf, String)

(defun (print Tree) (t) 
  (match t ((cases
    Sexpr l (print l)
    Leaf l (print l)))))

(defun (add_token String (List (List Tree))) ( token treelist)
  (if (= token "(")
      (cons (cons (Sexpr (car treelist)) (car (cdr treelist))) (cdr (cdr treelist)))
      (if (= token ")")
        (cons ((nil Tree)) treelist)
	(cons (cons (Leaf token) (car treelist)) (cdr treelist)))))

(defun parse (s) ((car . car) ((reduce add_token) (lex s) (list ((nil Tree))))))

(print (parse "((b) (a) ())" ))
