#include "prelude.lisp"
#include "ffi.lisp"


(defun zip (a b) (if (&& a b) (cons (list (car a) (car b)) (zip (cdr a) (cdr b))) (infer (list (list (car a) (car b)))))) 

(defun svghead ()
  (print "<svg version='1.1'
            width='600' height='600'
            viewBox='-.1 -.1 1.2 1.2'
            xmlns='http://www.w3.org/2000/svg'> " ))

(defun svgpt (p) (do 
  (print (car p)) 
  (print ", ") 
  ((print . car . cdr) p) 
  (print " ")))

(defun svgpath (pts) (do (print "
<polyline stroke-width='.002' fill='none' stroke='black' points='")
((map svgpt) 
 ((. (\ x . (+ (/ 1 2) (/ x 2)))) 
  (zip (linspace (- 1) 1 (len pts)) 
       ((. -) pts))))
(print "'/>
")))

(defun (^ B E) (base exp) 
  (if exp 
      (* base (^ base (- exp 1))) 
      (+ 1 ((zero B)))))
(defun fac (n) 
  (if n 
      (* n (fac (- n 1))) 
      1))

(defun svgtail () (print "</svg>"))

(defun ((svg F) X) (x) (do (svghead) (F x) (svgtail))) 

(defun sinterm (n t) 
  (* (^ (- 1) n) 
     (^ t (+ 1 (* n 2))) 
     (/ 1 (fac (+ 1 (* n 2)))))) 

(defun (pi) () (/ 314159265358979 
		  100000000000000))

(defun sin (t) (if (> 0 t) 
		 (- (sin (- t)))
		 (if (> t (pi))
                    (- (sin (- t (pi))))
		    (sum ((. sinterm) (range 8) t)))))

((svg svgpath) ((. *) (/ 1 10) ((. sin) (linspace 0 (* 30 (pi)) 1000))))
