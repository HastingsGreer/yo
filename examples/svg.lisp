#include "prelude.lisp"
#include "ffi.lisp"


(defun svgpt (p) (+
  (string (car p)) 
   ", " 
  ((string . car . cdr) p) 
  " "))

(defun svgpath (pts) (+ "
<polyline stroke-width='.002' fill='none' stroke='black' points='"
((reduce +) ((map svgpt) 
 ((. (\ x . (+ (/ 1 2) (/ x 2)))) 
  (zip (linspace (- 1) 1 (len pts)) 
       ((. -) pts)))) "")
 "'/>
"))

(defun svghead ()
  "<svg version='1.1'
	    width='600' height='600'
	    viewBox='-.1 -.1 1.2 1.2'
	    xmlns='http://www.w3.org/2000/svg'> " )
(defun svgtail () "</svg>")

(defun (svg X) (x) (+ (svghead) x (svgtail))) 

(defun sinplot (m) (write_file (svg (svgpath ((. *) (/ 1 4) ((. sin) (linspace 0 (* m (pi)) 10))))) "out.svg"))

(defun fib (n) (if (< 0 n) (+ (fib (- n 1)) (fib (- n 2))) 1))

(defun sinplotpause (m) (do (println "boo") (fib 1) (sinplot m)))

((. sinplotpause ) (range 1))
(write_file (svg "") "i.svg")
(sinplot 3)
(string (/ 1 2))



