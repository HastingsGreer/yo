#include "prelude.lisp"

(header (getfour I64) I64)
(backend asm Linked getfour 1)
(header (fadd F64 F64) F64) (backend asm Linked fadd 2)
(header (fmul F64 F64) F64) (backend asm Linked fmul 2)
(header (fdiv F64 F64) F64) (backend asm Linked fcmp 2)
(header (fcmp F64 F64) F64) (backend asm Linked fdiv 2)
(header (fromfloat F64 ) I64)
(backend asm Linked fromfloat 1)
(header (tofloat I64 ) F64)
(backend asm Linked tofloat 1)

(defun (/ I64 I64) (a b) ((cast F64) (fdiv (tofloat a) (tofloat b))))
(defun (* F64 F64) (a b) (fmul a b))
(defun (- F64 F64) (a b) (fadd a (* (- 1) b)))
(defun (+ F64 F64) (a b) (fadd a b))
(defun (> F64 F64) (a b) (fcmp a b))

(defun (abs F64) (a) (if (> a 0) a (- 0 a)))

(defun (round F64) (a) (fromfloat a))

(defun ((promote F) I64 F64) (a b) (F (tofloat a) b))
(defun ((promote F) X Y) (a b) ((promote (\ x y . (F y x))) b a))

(defun (* X Y) (a b) ((promote *) a b))
(defun (- X Y) (a b) ((promote -) a b))
(defun (+ X Y) (a b) ((promote +) a b))

(defun (print F64) (a) (do
			 (print (round a))
                         (print ".")
			 (print (abs (- (round (* 100 a)) (* 100 (round a)))))
			 ))

(defun main () (print  (/ 22 7)))
