#include "prelude.lisp"

(defun prime_impl (prime test) (if (neq test 1) (if (neq (mod prime test) 0) (prime_impl prime (sub test 1)) 0) 1))
(defun isprime (p) (if (neq p 1) (prime_impl p (sub p 1)) 0))


(defun main () ((map print_) ((filter isprime) (range 500))))

(defun zero_ (x) 0)
(defun (Consint I64) (n) ((cast Consint) ((map zero_) (range n))))
(defun (len (List T)) (l) (if l (add 1 (len (cdr l))) 0))
(defun (I64 Consint) (n) (len ((cast (List I64)) n)))
(defun (dec Consint) (n) ((cast Consint) (cdr ((cast (List I64)) n))))
(defun (inc Consint) (n) ((cast Consint) (cons 0 ((cast (List I64)) n))))
(defun (sub Consint Consint) (a b) (if b (sub (dec a) (dec b)) a))
(defun (sub Consint I64) (a b) (sub a (Consint b)))
(defun (sub I64 Consint) (a b) (sub (Consint a) b))
(defun (add Consint Consint) (a b) (if b (add (inc a) (dec b)) a))
(defun ((zero Consint)) () (Consint 0))
(header (if Consint T T) T)

(defun cain () (print_ (I64 (sub (Consint 7) 3))))

(defun (pair T T) (a b) (cons a (cons b ((nil T)))))

STRUCT2( (Signedof T), T, T, first, second)

(defun ((Signedof T) Q) (n) ((Signedof T) (T n )))
(defun ((Signedof T) T) (n) ((Signedof T) n ((zero T))))
(defun (I64 (Signedof T)) (n) (sub (first n) (second n)))
(defun ((zero (Signedof T))) () ((Signedof T) 0))

(defun (normform (Signedof T)) (n) (if (first n) (if (second n) (normform ((Signedof T) (sub (first n) 1) (sub (second n) 1))) n) n))

(defun (add (Signedof T) (Signedof T)) (a b) (normform ((Signedof T) (add (first a) (first b)) (add (second a) (second b)))))
(defun (sub (Signedof T) (Signedof T)) (a b) (normform ((Signedof T) (add (first a) (second b)) (add (second a) (first b)))))

(defun (sub (Signedof T) I64) (a b) (sub a ((Signedof T) b)))
(defun (sub I64 (Signedof T)) (a b) (sub ((Signedof T) a) b))
(defun (eq (Signedof T) (Signedof T)) (a b) (if (sub (first a) (first b)) 0 (if (sub (second a) (second b)) 0 1)))
(defun (eq (Signedof T) I64) (a b) (eq a ((Signedof T) b)))


(defun (add (Signedof T) I64) (a b) (add a ((Signedof T) b)))

(defun main () (print_ (I64 (sub ((Signedof I64) 7) ((Signedof I64) 3)))))

(defun main () (print_ (I64 (mod ((Signedof I64) 12) ((Signedof I64) 7)))))
(defun main () (print_ (isprime ((Signedof Consint) (Consint 13)))))






