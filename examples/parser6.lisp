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

(defun qprint (s) (do
		    (print "'")
		    (print s)
		    (print "' ")))

(defun (print (List String)) (ss) (do 
			       (print "(")
			       ((map qprint) ss)
			       (print ")")))

(print (do (lex "hello) world( (friend")))

ENUM3( Tree, Sexpr, (List Tree), Leaf, String, Lparen, Unit)

(defun (print Tree) (t) 
  (match t ((then
	      Sexpr l (print l)
	      Leaf l (print l)
	      Lparen _ (print "#Lparen")))))

(defun (add_token (List Tree) Tree) (treelist token) 
  (if treelist
    (match (car treelist) ((then
       Sexpr listcar (if listcar
		       (match (car listcar) ((then
				     Sexpr _ (cons (Sexpr (add_token listcar token)) (cdr treelist))
				     Leaf _ (cons (Sexpr (add_token listcar token)) (cdr treelist))
				     Lparen _ (cons token treelist)))
			    ((set listcar) listcar ((set token) token ((set treelist) treelist (Unit))))
			    ) 
		       (cons (Sexpr (add_token listcar token)) (cdr treelist)))
       Leaf listcar (cons token treelist)
       Lparen listcar (cons token treelist)))
     ((set treelist) treelist ((set token) token (Unit)))) // manual list of closed over locals
    (cons token treelist)))

(defun (deepen (List Tree)) (treelist)
  (if treelist
    (match (car treelist) ((then
       Sexpr listcar (cons (Sexpr (deepen listcar)) (cdr treelist))
       Leaf listcar (cons (Sexpr ((nil Tree))) treelist)
       Lparen listcar (cons (Sexpr ((nil Tree))) treelist)))
     ((set treelist) treelist (Unit)))
  (cons (Sexpr ((nil Tree))) treelist)))

(defun (add_any_token (List Tree) String) (treelist token)
  (if (= token "(")
    (add_token treelist (Lparen))
    (if (= token ")")
      (deepen treelist)
      (add_token treelist (Leaf token)))))




(print (add_token (add_token (add_token (deepen (list (Leaf "hi") (Leaf "bye"))) (Leaf "bdfsaa")) (Lparen)) (Leaf "hi")))
