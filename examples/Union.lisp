#include "prelude.lisp"

(defun ((Union (A B)) A) (a) ((cast (Union (A B))) (cons_ 0 ((cast I64) a))))
(defun ((Union (A B)) B) (b) ((cast (Union (A B))) (cons_ 1 ((cast I64) b))))


(defun ((Union (A B C)) A) (a) ((cast (Union (A B C))) (cons_ 0 ((cast I64) a))))
(defun ((Union (A B C)) B) (b) ((cast (Union (A B C))) (cons_ 1 ((cast I64) b))))
(defun ((Union (A B C)) C) (b) ((cast (Union (A B C))) (cons_ 2 ((cast I64) b))))

(defun ((dispatch F) (Union (A B))) (x) 
  (if (car_ ((cast I64) x)) 
      (F ((cast B) (cdr_ ((cast I64) x))))
      (F ((cast A) (cdr_ ((cast I64) x))))))

(defun ((dispatch F) (Union (A B C))) (x) 
  (if (= 0 (car_ ((cast I64) x)))
      (F ((cast A) (cdr_ ((cast I64) x))))
      (if (= 1 (car_ ((cast I64) x)))
          (F ((cast B) (cdr_ ((cast I64) x))))
          (F ((cast C) (cdr_ ((cast I64) x)))))))

// (defun (ucons T (List (Union U))) (x l) (cons ((Union U) x) l))


(defun (print (Union T)) (u) ((dispatch print) u))



STRUCT2(StringTree, (Union (I64 String StringTree)), (Union (None StringTree)), child, nextSibling)

(defun (None) () ((cast None) 0))
(defun StringTree (child rest) (StringTree ((Union (I64 String StringTree)) child)
					   ((Union (None StringTree)) rest)))

(defun (print None) (n) (print "None"))
(defun (printSiblings None) (n) 0)

(defun (printSiblings StringTree) (st) (do
					 (print (child st))
					 (print " ")
					 ((dispatch printSiblings) (nextSibling st))))
(defun (print StringTree) (st) (do 
				 (print "(")
				 (printSiblings st)
				 (print ")")
				 ))


// Runtime tagged lists: 

// (defun main () (print ((Union (String I64)) "Horse" )))

// (defun main () (print (ucons 100 (ucons "Horse " ( ucons 332 ((nil (Union (String I64)))))))))

(defun main () (print (StringTree (StringTree "ConsCell" (StringTree 87 (None)))  (StringTree "goodby" (None)))))
