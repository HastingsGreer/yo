#include "prelude.lisp"
#include "ffi.lisp"

STRUCT4((BinTree K V), K, V, (BinTree K V), (BinTree K V), :key, :value, :left, :right)

(header (if (BinTree K V) T T) T)
(defun (BinTree K V L R) (k v l r) ((BinTree K V) k v l r))

(defun (print (BinTree K V)) (t) 
			     (if t (do
			     (print "{ ")
			     (print (:key t))
			     (print ":")
			     (do 
			     (print (:value t))
			     (print " ")

			     (print (:left t))
			     (print (:right t)

				    )(print "}"))) (print "{}")))

(defun ((empty K V)) () (do ((cast (BinTree K V)) 0)))


(defun (get K (BinTree K V)) (key tree) 
  (if (= key (:key tree))
     (:value tree)
     (if (> key (:key tree))
       (get key (:right tree))
       (get key (:left tree)))))

(defun (set K V (BinTree K V)) (key value tree)
  (if (not tree)
      (BinTree key value ((empty K V)) ((empty K V)))
      (if (= (:key tree) key)
	  (BinTree key value (:left tree) (:right tree))
	  (if (> key (:key tree))
	      (BinTree (:key tree) (:value tree) (:left tree)
		       (set key value (:right tree)))
	      (BinTree (:key tree) (:value tree) 
		       (set key value (:left tree)) (:right tree))))))
(defun (set K V) (k v) (set k v ((empty K V))))



(print (set "cat" "meow" (set "dog" "bark" (set "horse" "neigh" ))))



