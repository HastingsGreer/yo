#include "prelude.lisp"

(header (shl I64 I64) I64)
(backend asm Instr shl)

(header (shr I64 I64) I64)
(backend asm Instr shr)

(header (imul I64 I64) I64)
(backend asm Instr imul)
(defun (mul I64 I64) (x y) (imul x y))

(defun (sign I64) (x) 
  (if x
    (if (shr x 63) 101 100)
     100))


// (defun main () (print (sign 0)))
#include "broadcast.lisp"
