#include "prelude.lisp"

(defun prime_impl (prime test)
  (if (!= test 1) 
      (if (!= (mod prime test) 0) 
	  (prime_impl prime (- test 1)) 
	  FALSE) 
      TRUE))
(defun isprime (p) 
  (if (!= p 1) 
      (prime_impl p (- p 1)) 
      FALSE))




// (defun main () ((map print) ((filter isprime) (range 500))))

(defun zero_ (x) 0)
(defun (Consint I64) (n) ((cast Consint) ((map zero_) (range n))))
(defun (len (List T)) (l) (if l (+ 1 (len (cdr l))) 0))
(defun (I64 Consint) (n) (len ((cast (List I64)) n)))
(defun (dec Consint) (n) ((cast Consint) (cdr ((cast (List I64)) n))))
(defun (inc Consint) (n) ((cast Consint) (cons 0 ((cast (List I64)) n))))
(defun (- Consint Consint) (a b) (if b (- (dec a) (dec b)) a))
(defun (- Consint I64) (a b) (- a (Consint b)))
(defun (- I64 Consint) (a b) (- (Consint a) b))
(defun (+ Consint Consint) (a b) (if b (+ (inc a) (dec b)) a))
(defun ((zero Consint)) () (Consint 0))
(header (if Consint T T) T)

// (defun main () (print_ (I64 (- (Consint 7) 3))))


STRUCT2( (Signedof T), T, T, first, second)

// Constructors
(defun ((Signedof T) Q) (n) ((Signedof T) (T n )))
(defun ((Signedof T) T) (n) ((Signedof T) n ((zero T))))
(defun (I64 (Signedof T)) (n) (- (first n) (second n)))
(defun ((zero (Signedof T))) () ((Signedof T) 0))

// Helpers
(defun (normform (Signedof T)) (n) 
  (if (!= (first n) 0)
      (if (!= (second n) 0)
	  (normform ((Signedof T) (- (first n) 1) (- (second n) 1)))
	  n) 
      n))

// Functions to be an integer
(defun (+ (Signedof T) (Signedof T)) (a b) 
  (normform ((Signedof T) (+ (first a) (first b)) (+ (second a) (second b)))))
(defun (- (Signedof T) (Signedof T)) (a b) 
  (normform ((Signedof T) (+ (first a) (second b)) (+ (second a) (first b)))))
(defun (= (Signedof T) (Signedof T)) (a b) 
  (if (- (first a) (first b)) 
      0 
      (if (- (second a) (second b)) 
	  0 
	  1)))

// Casts (would prefer to not have to manually do these) 
(defun (- (Signedof T) I64) (a b) (- a ((Signedof T) b)))
(defun (- I64 (Signedof T)) (a b) (- ((Signedof T) a) b))
(defun (= (Signedof T) I64) (a b) (= a ((Signedof T) b)))

// (defun main () (print (isprime ((Signedof Consint) (Consint 13)))))


(defun (+ (Signedof T) I64) (a b) (+ a ((Signedof T) b)))

//  (defun main () (print_ (I64 (- ((Signedof I64) 7) ((Signedof I64) 3)))))

// (defun cain () (print_ (I64 (mod ((Signedof I64) 12) ((Signedof I64) 7)))))



(defun cons_negative? (x) ((Signedof Consint) (Consint x)))
 (defun main () ((map print) ((map I64) ((map I64) ((filter isprime) ((map cons_negative?) (range 90)))))))
