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


// (defun main () (print (list (negative? (- 1)) (negative? 0) (negative? 1) (* 100 100))))
#endif
