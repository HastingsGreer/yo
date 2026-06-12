#include "prelude.lisp"
#include "Union.lisp"

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

//add token to list:
//if last element of list is a list
// cons (cdr self, (add token (car self))
//else
//  cons token self
//
//add ")" to a list:
//if last element of the list is a list:
//  if last element of the last element is a list:
//     cons (cdr self, (add ")" (car self))
//  else:
//     cons ")" self
//else:
//  return list
//
//(defun add_nonparen (token tree)
//  (if //    (Tree token tree)

(defun (isTree None) (_) 1)
(defun (isTree (Tree String)) (_) 1)
(defun (isTree String) (_) 0)

(defun (addToken TOKEN None) (token tree) (St token tree))
(defun (addToken TOKEN String) (token tree) (do (print "ERROR: added string to string") (St "None" (None))))
(defun (addToken TOKEN (Tree String)) (token tree) 
  (if ((match isTree) (:child tree))
    (St ((match addToken) token (:child tree)) (:nextSibling tree))
    (St token tree)))


(defun (isTreeTree None) (_) 0)
(defun (isTreeTree (Tree String)) (t) ((match isTree) (:child t)))
(defun (isTreeTree String) (_) 0)

(defun (addLParen String) (tree) (do (print "ERROR: end-list to string") (St "None" (None))))
(defun (addLParen None) (tree) (do (print "ERROR: end-list to None") (St "None" (None))))
(defun (addLParen (Tree String)) (tree) 
  (if ((match isTree) (:child tree))
    (if ((match isTreeTree) (:child tree))
       (St ((match addLParen) (:child tree)) (:nextSibling tree))
       (St "$$" tree))
    (do
      (print "Error, unmatched paren")
      (St ( None) (None)))))


(print (addLParen (addToken "boo" (addToken (None) (addToken "hi" (St (None) (St "hi" (None))))))))

(defun addTokenChecked (token tree)
  (if (= token "(")
    (addLParen tree)
    (if (= token ")")
      (addToken (None) tree)
      (addToken token tree))))

(defun parse (string) (treeFilter ((reduce addTokenChecked) (lex string) (St "$$"( None)))))

(defun (is$$ None) (_) 0) 
(defun (is$$ (Tree String)) (_) 0) 
(defun (is$$ String) (s) (= s "$$")) 

(defun (treeFilter T) (t) ((Union (String None (Tree String))) t))
(defun (treeFilter (Tree String)) (t) 
  (if ((match is$$) (:child t))
    ((match treeFilter) (:nextSibling t))
    ((Union (String None (Tree String)))( St ((match treeFilter) (:child t)) ((match restFilter) (:nextSibling t))))))

(defun (restFilter T) (t) ((Union (None (Tree String))) t))
(defun (restFilter (Tree String)) (t) 
  (if ((match is$$) (:child t))
    ((match restFilter) (:nextSibling t))
    ((Union (None (Tree String)))(St ((match treeFilter) (:child t)) ((match restFilter) (:nextSibling t))))))

(print (parse (readall)))
