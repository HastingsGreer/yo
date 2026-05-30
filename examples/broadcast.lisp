#include "prelude.lisp"

(defun ppmhead () (do
    (print_ 80)
    (do (print_ 51)
    (do (print_ 10)
    (do (print 60)
    (do (print 60)
    (do (print_ 10)
    (do (print 255)
        (print_ 10)))))))))

(defun sumsquare (a b) (eq 101 (sign (sub (add (mul a a) (mul b b)) 380))))

(defun circ (b) ((. sumsquare) (sing b) b))

(defun main () (do
		 (ppmhead)
		 ((. print) ((. mul) (sing (sing (triple 100 200 210))) (circ ((. sub) (range 60) 30))))
		 0
		 )
  
  )


