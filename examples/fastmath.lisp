#include "prelude.lisp"

(header (shl I64 I64) I64)
(backend asm Instr shl)

(header (shr I64 I64) I64)
(backend asm Instr shr)

(header (imul I64 I64) I64)
(backend asm Instr imul)

(defun main () (print (imul 9 9)))
