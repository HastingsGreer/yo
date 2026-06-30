#ifndef FFI_LISP
#define FFI_LISP

#include "prelude.lisp"
#include "fastmath.lisp"
(header (fadd F64 F64) F64) (backend asm Linked fadd 2)
(backend js lit fadd (a b) (a + b))
(header (fmul F64 F64) F64) (backend asm Linked fmul 2)
(backend js lit fmul (a b) (a * b))
(header (fdiv F64 F64) F64) (backend asm Linked fdiv 2)
(backend js lit fdiv (a b) (a / b))
(header (fcmp F64 F64) I64) (backend asm Linked fcmp 2)
(backend js lit fcmp (a b) (a > b))

(header (tofloat I64 ) F64) (backend asm Linked tofloat 1)
(backend js lit tofloat ( b) (b))
(header (fromfloat F64 ) I64) (backend asm Linked fromfloat 1)
(backend js lit fromfloat ( b) (0 | b))

(defun (/ I64 I64) (a b) ((cast F64) (fdiv (tofloat a) (tofloat b))))
(defun (/ F64 F64) (a b) (fdiv a b))
(defun (* F64 F64) (a b) (fmul a b))
(defun (- F64 F64) (a b) (fadd a (* (- 1) b)))
(defun (+ F64 F64) (a b) (fadd a b))
(defun (> F64 F64) (a b) (fcmp a b))
(defun (abs F64) (a) (if (> a 0) a (- 0 a)))
(defun (round F64) (a) (fromfloat a))
(defun (fracpart F64) (a) (- a (round a)))
(defun ((zero F64)) () (tofloat 0))
(defun ((error X)) () look_up_one_line_the_errors_there)

(defun ((promote F) I64 F64) (a b) (F (tofloat a) b))
(defun ((promote F) X Y) (a b) 
  ((promote (\ x y . (F y x))) b a))
(defun ((promote (\ x y . ((\ x y . F) y x))) X Y) (a b) 
  ((error (no base operator for F on X and Y))))

(defun (* X Y) (a b) ((promote *) a b))
(defun (/ X Y) (a b) ((promote /) a b))
(defun (- X Y) (a b) ((promote -) a b))
(defun (+ X Y) (a b) ((promote +) a b))
(defun (> X Y) (a b) ((promote >) a b))
(defun (< Y X) (a b) ((promote >) a b))

(defun (stringTail F64 I64) (k digits)
  (if digits
    (+
      (string (round (* 10 k)))
      (stringTail (fracpart (* 10 k)) (- digits 1)))
  ""))

(defun (string F64) (a) (+
			 (if (> 0 a) "-" "")
			 (string (abs (round a)))
                         "."
			 (stringTail (abs (fracpart a)) 8)
			 ))
(defun normalizedRange (n) ((. /) ((. +) (/ 1 2) (range n)) n))

(defun linspace (a b n) ((. +) a ((. *) (- b a) (normalizedRange n))))


(header (yostring_to_cstring String) I64)
(backend asm Linked yostring_to_cstring 1)

(header (cstring_to_yostring I64) String)
(backend asm Linked cstring_to_yostring 1)
(header (write_cstring_to_filename I64 I64) I64)
(backend asm Linked write_cstring_to_filename 2)
(header (read_cstring_from_filename I64) I64)
(backend asm Linked read_cstring_from_filename 1)

(defun (write_file String String) (string filename) (write_cstring_to_filename (yostring_to_cstring string) (yostring_to_cstring filename)))
(defun (read_file String) (filename) (cstring_to_yostring (read_cstring_from_filename (yostring_to_cstring filename))))
#endif
(print (read_file "message.txt"))
