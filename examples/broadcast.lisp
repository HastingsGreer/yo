#include "prelude.lisp"
#include "fastmath.lisp"

// ppmhead is an ordinary function. This isn't haskell, 
// functions are allowed to have side effects
(defun ppmhead () (print "P3\n60 60\n255\n"))

// sumsquare has no type annotations, but we call it with integers.
// in yo, by default functions are totally polymorphic- sumsquare 
// would work fine with floats or bigints, but fail to compile
// with a complex datatype that doesn't implement negative?
(defun sumsquare (a b) (negative? (- (+ (* a a) (* b b)) 380)))

// (circ (List I64)) is a function with a type annotation. b is 
// a list of integers. yo
// type annotations always denote the argument types. return types
// are deduced. yo type annotations are used for dispatch or for 
// documentation / clarity.

// (defun (circ (List I64)) (b) ...)
// means b : List I64

// (. sumsquare) is a broadcasted function call, like numpy's arraywise operations or julia's f.(x, y). circ will return a list of list of integers.
(defun (circ (List I64)) (b) ((. sumsquare) (list b) b))

(defun main () (do
		 (ppmhead)
		 ((. print) (
			     (. *)  
			     (circ ((. -) (range 60) 30) ) 
			     (list (list (list 0 200 210)))))
		 0
		 ))


