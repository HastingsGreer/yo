#include "parser7.lisp"

(defun (print_indent I64) (n) (do ((map (\ x . (print "  "))) (range n)) 0))

(defun (pprint_wrapped Tree I64) (t indent)
  (do
    (println "")
    (print_indent indent)
    (pprint t indent)))

(defun (len Tree) (t) (match t ((cases
    Sexpr l (+ 2 (sum ((map len) l)))
    Leaf l (+ 1 (len l))))))

(defun (fprint Tree) (t)
  (match t ((cases
    Sexpr l (do
      (print_ 40)
      (if l 
        (do
          (fprint (car l))
          ((map (\ x . (do (print " ") (fprint x) ))) (cdr l))
          0)
        0)
      (print_ 41))
    Leaf l (do (print l) (print ""))))))

(defun (inline_args Tree) (expr)
        (match expr ((cases 
			  Sexpr ll 1 
			  Leaf lf (if (in lf (list "defun"))
				    3
				    (if (in lf (list "if" "match"))
				      2
				      (if (in lf (list "cases"))
					99 1)))))))

  

(defun (pprint Tree I64) (t indent) 
 (if (negative? (- (len t) 40))
  (fprint t)
  (match t ((cases
    Sexpr l (do
      (print_ 40)
      (if l 
	(if (= (inline_args (car l)) 1)
         (do
          (pprint (car l) (+ indent 1))
          ((. pprint_wrapped) (cdr l) (+ indent 1))
	  0
          )
	 (if (= (inline_args (car l)) 2)
          (do
           (pprint (car l) (+ indent 1))
	   (print " ")
           (fprint ((car . cdr) l))
	   (do
           ((. pprint_wrapped) ((cdr . cdr) l) (+ indent 1))
           0))
	  (if (= (inline_args (car l)) 3)
           (do
            (fprint (car l))
	    (print " ")
            (fprint ((car . cdr) l))
	    (print " ")
            (fprint ((car . cdr . cdr) l))
	    (do
             ((. pprint_wrapped) ((cdr . cdr . cdr) l) (+ indent 1))
             0))
	  (do
            (println (car l))
	    (print_indent indent)
            (fprint ((car . cdr) l))
	    (print " ")
            (fprint ((car . cdr . cdr) l))
	    (do
            ((. pprint_wrapped) ((cdr . cdr . cdr) l) (+ indent 1))
            0))))

        )
        0)
      (print_ 41))
    Leaf l (print l)))
  ((set indent) indent (Unit)))))

(defun (pretty Tree) (t) (do (pprint t 0) (println "")))

(pretty (parse (+ "(" (readall) ")")))
