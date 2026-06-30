#ifndef fastmath
#define fastmath

#include "prelude.lisp"

(header (shl I64 I64) I64)
(backend asm Instr shl)

(header (shr I64 I64) I64)
(backend asm Instr shr)
(backend js lit shr (a b) ( Number(BigInt.asUintN(64, BigInt(a)) >> BigInt(b))))

(header (imul I64 I64) I64)
(backend js lit imul (a b) (a * b))

(backend asm Instr imul)
(defun (* I64 I64) (x y) (imul x y))

(defun (negative? I64) (x) 
  (if x
    (if (shr x 63) 1 0)
     0))
(defun (> I64 I64) (a b) (negative? (- b a)))
(defun (< I64 I64) (a b) (negative? (- a b)))

(defun (^ B E) (base exp) 
  (if exp 
      (* base (^ base (- exp 1))) 
      (+ 1 ((zero B)))))
(defun fac (n) 
  (if n 
      (* n (fac (- n 1))) 
      1))

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


// (defun main () (print (list (negative? (- 1)) (negative? 0) (negative? 1) (* 100 100))))
#endif
