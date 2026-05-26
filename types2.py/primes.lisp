#include "prelude.lisp"

(defun prime_impl (prime test) (if (sub test 1) (if (mod prime test) (prime_impl prime (sub test 1)) 0) 1))
(defun isprime (p) (if (sub p 1) (prime_impl p (sub p 1)) 0))


(defun main () ((map print_) ((filter isprime) (range 500))))

(defun zero_ (x) 0)
(defun (consint I64) (n) ((cast Consint) ((map zero_) (range n))))
(defun (len (List T)) (l) (if l (add 1 (len (cdr l))) 0))
(defun (I64 Consint) (n) (len ((cast (List I64)) n)))
(defun (dec Consint) (n) ((cast Consint) (cdr ((Cast List) n))))
(defun (sub Consint Consint) (a b) (if b (sub (dec a) (dec b)) a))

(defun main () (print_ (I64 (consint 9))))

