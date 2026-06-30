#include "ffi.lisp"
(defun inbounds (x y) (> 1 (+ (* x x) (* y y))))
#define N 300
(println 
  (* 4 (/ 
	 (sum ((. inbounds) 
	       (normalizedRange N) 
	       (list (normalizedRange N)))) 
	 (* N N))))

