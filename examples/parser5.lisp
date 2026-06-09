#include "prelude.lisp"
#include "Union.lisp"

(defun (read) () (Char (read_)))
(defun readall_impl (char) (if char (cons char (readall_impl (read))) (nil (Char 0) )))

(defun ((then T)) () ((cast T) 0))
(defun ((let NAME) ARGTYPE BODY) (NAME _) BODY)
(defun ((let NAMEONE NAMETWO) ARGTYPEONE ARGTYPETWO  BODY) (NAMEONE NAMETWO _) BODY)
(defun readall () (String (readall_impl (read))))

(defun in (thing collection) (if collection (if (= thing (car collection)) 1 (in thing (cdr collection))) 0))

(defun canGlomp (a b)
  (if (in a "!@#$%^&*()><.,;':") 0
     (if (in b "!@#$%^&*()><.,;':") 0 1)))

(defun (combine Char (List String)) (char lexed) 
  (if (|| (= char " ") (= char "\n"))
    (cons "" (cons "#" lexed))
    (if (= char "(")
        (cons "" (cons "(" (cons "#" lexed)))
	(if (= char ")")
	   (cons "" (cons "#" (cons ")" lexed)))
	   (if (car lexed)
	     (if (canGlomp (car lexed) char)
                 (cons (cons char (car lexed))
		       (cdr lexed))
		 (cons (cons char "") lexed))
	     (cons (cons char (car lexed)) (cdr lexed)))))))

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

(defun (hasHash None) (_) 0) 
(defun (hasHash (Tree String)) (t) ((match isHash) (:child t)))

(defun (isHash None) (_) 0) 
(defun (isHash (Tree String)) (_) 0) 
(defun (isHash String) (s) (= s "#")) 

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

// ok the situation
// can't do it without parsing the tree structure first
// a node can be String, "#", None, or Tree
// process a stream of nodes
// starting state: result = [$$]
//                 glommed = [$$]
// see # [$$]: do nothing
// see # [some]: push glommed, zero glommed
// see x# [$$]: push x
// see x# [some]: push x to glommed
// see xy [$$]: push x and y to glommed, pop result
// see xx [some]: push x to glommed
// see eof: do nothing

STRUCT2(GlommingState, (Tree String), (Tree String), :result, :glommed)

(defun (assertTree (Tree String)) (t) t)
(defun (assertTree None) (t) (do (print "assertion failed, not tree") (St "" (None))))


(defun (glomOne (Tree String) GlommingState) (tree state) 
  (if ((match isHash) (:child tree))
    (if ((match is$$) (:child (:glommed state)))
      state
      (GlommingState (St (:glommed state) (:result state)) (St "$$" (None))))
    (if ((match hasHash) (:nextSibling tree))
      (if ((match is$$) (:child (:glommed state)))
	(GlommingState (St (:child tree) (:result state)) (:glommed state))
	(GlommingState (:result state) (St (:child tree) (:glommed state))))
      (if ((match is$$) (:child (:glommed state)))
        (GlommingState 
	  ((match assertTree) (:nextSibling (:result state)))
	  (St (:child tree) (St (:child ((match assertTree) (:nextSibling tree))) (:glommed state))))
        (GlommingState (:result state) (St (:child tree) (:glommed state)))))))



(defun (glomOne None GlommingState) (tree state) state)

(defun ((tailReduce F) None INIT) (t i) i)
(defun ((tailReduce F) String INIT) (t i) (do (print "tried to reduce a non tree node") i))
(defun ((tailReduce F) (Tree T) INIT) (t i) (F t ((match (tailReduce F)) (:nextSibling t) i))) 

(defun glom (t) (:result ((match (tailReduce glomOne)) t (GlommingState (St "$$" (None)) (St "$$" (None))))))


  
  ((let code) (readall) ((then (do

(print (parse code))
(print "\n")
(print (glom (parse code)))))))
