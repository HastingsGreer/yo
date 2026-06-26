#include "prelude.lisp"
#include "fastmath.lisp"
(header (fadd F64 F64) F64) (backend asm Linked fadd 2)
(backend js lit fadd (a b) (a + b))
(header (fmul F64 F64) F64) (backend asm Linked fmul 2)
(backend js lit fmul (a b) (a * b))
(header (fdiv F64 F64) F64) (backend asm Linked fdiv 2)
(backend js lit fdiv (a b) (a / b))
(header (fcmp F64 F64) I64) (backend asm Linked fcmp 2)
(backend js lit fcmp (a b) (a > b))

(header (tofloat I64 ) F64) (backend asm Linked tofloat 1)
(backend js lit tofloat ( b) (b))
(header (fromfloat F64 ) I64) (backend asm Linked fromfloat 1)
(backend js lit fromfloat ( b) (0 | b))

(defun (/ I64 I64) (a b) ((cast F64) (fdiv (tofloat a) (tofloat b))))
(defun (/ F64 F64) (a b) (fdiv a b))
(defun (* F64 F64) (a b) (fmul a b))
(defun (- F64 F64) (a b) (fadd a (* (- 1) b)))
(defun (+ F64 F64) (a b) (fadd a b))
(defun (> F64 F64) (a b) (fcmp a b))
(defun (abs F64) (a) (if (> a 0) a (- 0 a)))
(defun (round F64) (a) (fromfloat a))
(defun (fracpart F64) (a) (- a (round a)))
(defun ((zero F64)) () (tofloat 0))

(defun ((promote F) I64 F64) (a b) (F (tofloat a) b))
(defun ((promote F) X Y) (a b) 
  ((promote (\ x y . (F y x))) b a))

(defun (* X Y) (a b) ((promote *) a b))
(defun (/ X Y) (a b) ((promote /) a b))
(defun (- X Y) (a b) ((promote -) a b))
(defun (+ X Y) (a b) ((promote +) a b))
(defun (> X Y) (a b) ((promote >) a b))
(defun (< Y X) (a b) ((promote >) a b))

(defun (printTail F64 I64) (k digits)
  (if digits
    (do
      (print (round (* 10 k)))
      (printTail (fracpart (* 10 k)) (- digits 1)))
  0))

(defun (print F64) (a) (do
			 (if (> 0 a) (print "-") 0)
			 (print (abs (round a)))
                         (print ".")
			 (printTail (abs (fracpart a)) 8)
			 ))
(defun normalizedRange (n) ((. /) ((. +) (/ 1 2) (range n)) n))

(defun linspace (a b n) ((. +) a ((. *) (- b a) (normalizedRange n))))
(println (/ 22 7))
