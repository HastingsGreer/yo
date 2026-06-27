#include "prelude.lisp"

(println 3)
(header (if (Option T) X X) X)

(defun (None T) (t) ((cast (Option T)) 0))
(defun (Some T) (t) ((cast (Option T)) t))
(defun (None) () ((cast None) 0))
(defun ((? F) (Option T)) (o) 
  (if o 
    (Some (F ((cast T) o)))
    (None (infer (F ((cast T) 0))))))
(defun ((? F) (Option (Option T))) (t) ((? F) ((cast (Option T)) t)))
(defun ((? (map F)) (Option T)) (o) 
  (if o 
    (Some ((map F) ((cast T) o)))
    o))

(defun (cons T None) (car cdr)
  ((cast (SList T)) (cons_ ((cast I64) car) 0)))
(defun (cons T (SList T)) (car cdr)
  ((cast (SList T)) (cons_ ((cast I64) car) ((cast I64) cdr))))
(defun (cons T (Option (SList T))) (car cdr)
  ((cast (SList T)) (cons_ ((cast I64) car) ((cast I64) cdr))))

(defun (car (SList T)) (l) ((cast T) (car_ ((cast I64) l))))
(defun (cdr (SList T)) (l) ((cast (Option (SList T))) (cdr_ ((cast I64) l))))

(defun ((map F) (SList T)) (l) 
  (cons (F (car l)) ((? (map F)) (cdr l))))
(defun ((map F) (Option (SList T))) (l) 
  (cons (F (car l)) ((? (map F)) (cdr l))))

(defun (print (SList T)) (l) ((map print) l))


((? print) ((? cdr) (cdr (cons 32 (cons 3 (cons 2222 (None)))))))

