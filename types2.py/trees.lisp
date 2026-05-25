(header ((cast Y) X) Y)
(header (sub I64 I64) I64)
(header (infer T) T)
(header (cons_ I64 I64) I64)
(header (car_ I64) I64)
(header (cdr_ I64) I64)
(header (if C T T) T)

(defun ((zero T)) () ((cast T) 0))
(defun (nil T) (x) ((zero (List T))))

(defun (cons T (List T)) (e l) ((cast (List T)) (cons_ ((cast I64) e) ((cast I64) l)))) 
(defun (car (List T)) (l) ((cast T) (car_ ((cast I64) l))))
(defun (cdr (List T)) (l) ((cast T) (cdr_ ((cast I64) l))))

(defun ((map F) (List T)) (l) (if l (cons (F (car l)) ((map F) (cdr l))) (nil (infer (F ((zero T)))))))

(defun (add X X) (a b) (sub a (sub 0 b)))

(defun (range T) (n) (if n (cons n (range (sub n 1))) (nil I64)))

(defun (main) () (range 4))
