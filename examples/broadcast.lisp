#include "prelude.lisp"
#include "fastmath.lisp"

(defun ppmhead () (print "P3\n60 60\n255\n"))

(defun sumsquare (a b) (= 101 (sign (- (+ (* a a) (* b b)) 380))))

(defun circ (b) ((. sumsquare) (sing b) b))

(defun main () (do
		 (ppmhead)
		 ((. print) ((. *)  (circ ((. -) (range 60) 30) ) (sing (sing (triple 100 200 210)))))
		 0
		 )
  
  )


