#ifndef fastmath
#define fastmath

#include "prelude.lisp"

(header (shl I64 I64) I64)
(backend asm Instr shl)

(header (shr I64 I64) I64)
(backend asm Instr shr)

(header (imul I64 I64) I64)
(backend asm Instr imul)
(defun (* I64 I64) (x y) (imul x y))

(defun (negative? I64) (x) 
  (if x
    (if (shr x 63) 1 0)
     0))


// (defun main () (print (list (negative? (- 1)) (negative? 0) (negative? 1) (* 100 100))))
#endif#
