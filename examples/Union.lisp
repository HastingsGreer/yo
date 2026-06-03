#include "prelude.lisp"

(defun ((Union (A B)) A) (a) ((cast (Union (A B))) (cons_ 0 ((cast I64) a))))
(defun ((Union (A B)) B) (b) ((cast (Union (A B))) (cons_ 1 ((cast I64) b))))


(defun ((Union (A B C)) A) (x) ((cast (Union (A B C))) (cons_ 0 ((cast I64) x))))
(defun ((Union (A B C)) B) (x) ((cast (Union (A B C))) (cons_ 1 ((cast I64) x))))
(defun ((Union (A B C)) C) (x) ((cast (Union (A B C))) (cons_ 2 ((cast I64) x))))

(defun ((match F) (Union (A B))) (x) 
  (if (car_ ((cast I64) x)) 
      (F ((cast B) (cdr_ ((cast I64) x))))
      (F ((cast A) (cdr_ ((cast I64) x))))))

(defun ((match F) (Union (A B C))) (x) 
  (if (= 0 (car_ ((cast I64) x)))
      (F ((cast A) (cdr_ ((cast I64) x))))
      (if (= 1 (car_ ((cast I64) x)))
          (F ((cast B) (cdr_ ((cast I64) x))))
          (F ((cast C) (cdr_ ((cast I64) x)))))))

(defun (ucons T (List (Union U))) (x l) (cons ((Union U) x) l))

(defun (print (Union T)) (u) ((match print) u))

STRUCT2((Tree T), (Union (T (Tree T))), (Union (None (Tree T))), child, nextSibling)
(defun (None) () ((cast None) 0))
(defun ((Tree T) X Y) (child rest) ((Tree T) ((Union (T (Tree T))) child)
					   ((Union (None (Tree T))) rest)))

(defun (print None) (n) (print "None"))
(defun (printSiblings None) (n) 0)

(defun (printSiblings (Tree String)) (st) (do
					 (print (child st))
					 (print " ")
					 ((match printSiblings) (nextSibling st))))
(defun (print (Tree String)) (st) (do 
				 (print "(")
				 (printSiblings st)
				 (print ")")
				 ))


#define St (Tree String)

(defun main () (print (St (St "ConsCell" (St "87" (None)))  (St "goodby" (None)))))
