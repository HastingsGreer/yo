#include "prelude.lisp"

(defun prime_impl (prime test) (if (sub test 1) (if (mod prime test) (prime_impl prime (sub test 1)) 0) 1))
(defun isprime (p) (if (sub p 1) (prime_impl p (sub p 1)) 0))


(defun main () ((map print_) ((filter isprime) (range 500))))


