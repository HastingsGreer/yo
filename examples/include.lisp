#include "prelude.lisp"
#include "parser7.lisp"
#include "pprint.lisp"
#include "bintree.lisp"

(defun ((panic MESSAGE TYPE)) () (do
				   (println "")
				   (println "RUNTIME PANIC:")
				   (println MESSAGE)
				   (println "")
				   ((cast TYPE) (car ((nil I64))))))

(defun (split (List T) T) (l i)
  (if l
    (if (= (car l) i)
      (cons ((nil T)) (split (cdr l) i))
      ((let downcall i newchar) 
       (split (cdr l) i)
       i
       (car l)
       ((then 
	  (cons (cons newchar (car downcall)) (cdr downcall))))))
    (list l)))


(defun ((split SEP) L) (l) (split l SEP))
(defun (split String String) (l i)
  (if  (:chars i)
    (if (cdr (:chars i))
      ((panic "split uses one char delimiter" (List String)))
      ((map String) (split (:chars l) (car (:chars i)))))
    ((panic "split on empty string" (List String)))))

(defun files_included_in (f) 
 ((((map (car . cdr . (split (String (list (Char 34)))) . car . cdr))
      . (filter (\ x . (= (car x) "include")))
      . (map ((split " ") . car . cdr))
      . (filter (\ x . (> (len x) 1)))
      . (map (split "#"))) 
      .	(split "\n")) (read_file (+ "examples/" f))))

(defun expand_files (files) (uniq (cat files (flatten ((map files_included_in) files)))))

(defun uniq (ss) (walk (treeof ss) ))

(defun treeof (ss) ((reduce (\ x y . (set x 0 y))) ss (set (car ss) 0)))

(defun (walk (BinTree K V)) (bintree) (if bintree (cat (cat (walk (:left bintree)) (list (:key bintree))) (walk (:right bintree))) ((nil K))))

(defun ((fixedpoint F) X) (x)
  (do
  ((let x fx) x (F x) 
	      ((then 
		 (if (= x fx)
		   x
		   ((fixedpoint F) fx)))))))

(defun (= (List T) (List T)) (l1 l2)
  (if l1
    (if l2
      (if (= (car l1) (car l2))
	(= (cdr l1) (cdr l2))
	0)
      1)
    (if l2 0 1)))

(print ((fixedpoint expand_files)  (list "include.lisp")))

//(print (> "abd" "abe"))
