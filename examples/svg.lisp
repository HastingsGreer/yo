#include "prelude.lisp"
#include "ffi.lisp"
#include "Union.lisp"


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

(defun sinplot (m) (write_file (svg (svgpath ((. *) (/ 1 4) ((. sin) (linspace 0 (* m (pi)) 100))))) "out.svg"))


STRUCT2(Lineplot, (List F64), (List F64), :xs, :ys)
STRUCT2(Scatterplot, (List F64), (List F64), :xs, :ys)

(defun (svg (List (Union Lineplot Scatterplot))) (figs) 
  (+ 
    (svghead) 
    ((reduce +) ((map (match show)) figs) "")
    (svgtail)
    )
  )

(sinplot 6)
