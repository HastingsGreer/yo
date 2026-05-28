#include "prelude.lisp"

(defun printfirst (a b) (print a))

(defun sumsquare (a b) (add (mul a a) (mul b b)))

(defun circ (b) ((broadcast sumsquare) (sing b) b))

(defun main () (print (circ (range 10))))


(defun ((broadcast F) A B) (a b) (F a b))

(defun ((broadcast F) (List A) B) (a b) (if a 
					    (cons (F (car a) b) ((broadcast F) (cdr a) b))
					    (nil (infer (F ((nilptr A)) b)))))

(defun ((broadcast F) A (List B)) (a b) (if b 
					    (cons (F a (car b)) ((broadcast F) a (cdr b)))
					    (nil (infer (F a (car b))))))

(defun ((broadcast F) (List A) (List B)) (a b)
	  (cons 
	    ((broadcast F) (car a) (car b)) 
	    (if (cdr a)
	        (if (cdr b) 
		    ((broadcast F) (cdr a) (cdr b) )
		    ((broadcast F) (cdr a) b))
		(if (cdr b)
		    ((broadcast F) a (cdr b))
		    (nil (infer ((broadcast F) (car a) (car b))))))))




