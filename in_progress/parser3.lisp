#include "prelude.lisp"
(defun ((then T)) () ((cast T) 0))
(defun ((\ X . BODY) ARGTYPE) (X) BODY)

(defun ((let NAME) ARGTYPE BODY) (NAME _) BODY)
(defun ((let NAMEONE NAMETWO) ARGTYPEONE ARGTYPETWO  BODY) (NAMEONE NAMETWO _) BODY)

(defun (= String Char) (s c) (= (:charcode (car (:chars s))) (:charcode c)))
(defun (= Char String) (c s) (= (:charcode (car (:chars s))) (:charcode c)))
(defun || (a b) (if a 1 b))
(defun || (a b c) (if a 1 (if b 1 c)))


(defun (read) () (Char (read_)))

(print (read))

STRUCT3(Tree, Tree, Tree, String, :child, :nextchild, :data)

(defun niltree () ((nilptr Tree)))

(defun (Tree String) (s) (Tree (niltree) (niltree) s))
(defun (Tree String Tree) (s t) (Tree (niltree) t s))
(header (if Tree T T) T)


(defun (Tree Tree Tree) (child nextchild) (Tree child nextchild ((nilptr String))))

(defun (printchildren Tree) (t) (do
				  (print t)
				  (if (:nextchild t) (printchildren (:nextchild t)) 0)
				  ))

(defun (print Tree) (t) (do
    (if (:chars (:data t))
      (do (print (:data t)) (print " "))
      (if (:child t) 
	(do
	  (print "(")
	  (printchildren (:child t))
	  (print ")")
	)
	0))))

(print (Tree (Tree "hello" (Tree "friend")) (niltree)))

STRUCT2(ParseAtomState, (List Char), (List Char), :atom, :rest)

(defun (print ParseAtomState) (p) (do
   (print ":atom")
   (print (:atom p))
   (print ":rest")
   (print (:rest p))))

(defun separator? (c) (|| (= c " ") (= c "\n") (= c ")")))

(defun example_main () 
  ((let y z) 
   (+ ((\ x . (+ x x)) 4) 4) 
   1000
   ((then (print (+ y z))))))

(defun parseAtom2list (chars2parse)
  ((let chars2parse downstack) 
        chars2parse 
	(if (separator? (car chars2parse))
            (ParseAtomState ((nil Char)) chars2parse)
            (parseAtom2list (cdr chars2parse)))
   ((then 
  (ParseAtomState 
    (if (separator? (car chars2parse)) ((nil Char)) (cons (car chars2parse) (:atom downstack))) 
    (:rest downstack))))))


STRUCT2(ParseTreeState, Tree, (List Char), :atom, :rest)
(defun (print ParseTreeState) (p) (do
   (print ":atom")
   (print (:atom p))
   (print ":rest")
   (print (:rest p))))

(defun parseAtom2Tree (chars2parse) 
  (parseAtom2Tree_letlift (parseAtom2list chars2parse)))
(defun parseAtom2Tree_letlift (downstack)
  (ParseTreeState (Tree (String (:atom downstack))) (:rest downstack)))

(defun parse2Tree (chars2parse)
  (let downstack ))


(print (parseAtom2Tree (:chars "hello world")))


