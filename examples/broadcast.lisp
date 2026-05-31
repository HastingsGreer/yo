#include "prelude.lisp"

(defun ppmhead () (print "P3\n60 60\n255\n"))

(defun sumsquare (a b) (eq 101 (sign (sub (add (mul a a) (mul b b)) 380))))

(defun circ (b) ((. sumsquare) (sing b) b))

(defun main () (do
		 (ppmhead)
		 ((. print) ((. mul) (sing (sing (triple 100 200 210))) (circ ((. sub) (range 60) 30))))
		 0
		 )
  
  )


