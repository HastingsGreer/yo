#include "prelude.lisp"
(defun (print X_) (_) (print "X "))
(defun (print Y_) (_) (print "Y "))
(defun (print X) (_) (print X))
(defun (print (Mul X Y)) (_) (do 
    (print "(") (print ((sentinel X)))
    (print "* ") 
    (print ((sentinel Y)))
    (print ")")))
(defun (print (Add X Y)) (_) (do 
    (print "(")
    (print ((sentinel X)))
    (print "+ ") 
    (print ((sentinel Y)))
    (print ")")))

(defun (Add A B) (a b) ((sentinel (Add A B))))
(defun (Add 0 B) (a b) b)
(defun (Add A 0) (a b) a)
(defun (Mul A B) (a b) ((sentinel (Mul A B))))
(defun (Mul 0 B) (a b) ((sentinel 0)))
(defun (Mul A 0) (a b) ((sentinel 0)))
(defun (Mul 1 B) (a b) b)
(defun (Mul A 1) (a b) a)

(defun (simplify (Derivative X_)) (_) ((sentinel 1)))
(defun (simplify (Derivative Y_)) (_) ((sentinel 0)))
(defun (simplify (Derivative OTHER)) (_) ((sentinel 0)))

(defun (simplify (Derivative (Add A B))) (_) 
  (Add 
    (simplify ((sentinel (Derivative A))))
    (simplify ((sentinel (Derivative B))))))
(defun (simplify (Derivative (Mul A B))) (_) 
  (Add 
    (Mul ((sentinel B)) (simplify ((sentinel (Derivative A)))))
    (Mul ((sentinel A)) (simplify ((sentinel (Derivative B)))))))

(defun ((λX. BODY) XTYPE) (X_) BODY) 
(defun (Add I64 I64) (a b) (+ a b))
(defun (Mul I64 I64) (a b) (* a b))

(defun (print_and_eval EXPR) (expr) (do
  (print expr)
  (print "\n x = 10 \n")
  (print ((λX. EXPR) 10))
  (print "\n")))

(defun (normal_and_deriv EXPR) (expr) (do
  (print_and_eval expr)
  (print "derivative\n")
  (print_and_eval (simplify ((sentinel (Derivative EXPR)))))))
(normal_and_deriv ((sentinel (Mul (Add X_ X_) (Mul X_ (Add 12 X_))))))
