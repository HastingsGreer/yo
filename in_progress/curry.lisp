
#include "prelude.lisp"

(defun ((\ XNAME . \ YNAME . BODY) YTYPE) (y) ((cast (\ XNAME . \ YNAME . BODY YTYPE)) y))  

(defun (apply (\ XNAME . \ YNAME . BODY YTYPE) XTYPE) (y x) ((\ XNAME YNAME . BODY) x ((cast YTYPE)  y)))

(println (apply ((\ x . \ y . (- x y)) 3) 4))
