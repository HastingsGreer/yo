(header ((cast Y) X) Y)
(header (sub I64 I64) I64)
(header (infer T) T)
(header (cons_ I64 I64) I64)
(header (car_ I64) I64)
(header (print_ I64) I64)
(header (cdr_ I64) I64)
(header (if C T T) T)

(defun ((zero I64)) () ((cast I64) 0))

(defun ((nilptr T)) () ((cast (Option T)) 0))
(defun (nil T) (x) ((nilptr (List T))))

(defun ((unwrap T F) (Option X)) (o) (if o (T ((cast X) o)) (F)))
(defun ((unwrap T F) (Option (Option X))) (o) ((unwrap T F) ((cast Option X) o)))
(defun (Some T) (t) ((cast (Option T)) t))

(defun (cons T (List T)) (e l) ((cast (List T)) (cons_ ((cast I64) e) ((cast I64) l)))) 
(defun (cons T (Option (List T))) (e l) ((cast (List T)) (cons_ ((cast I64) e) ((cast I64) l)))) 
(defun (car (List T)) (l) ((cast T) (car_ ((cast I64) l))))
(defun (cdr (List T)) (l) ((cast (Option (List T))) (cdr_ ((cast I64) l))))
(defun (cdr (Option (List T))) (l) ((unwrap cdr (nilptr (List T))) l))



(defun havel (x) (print_ (car x)))
(defun nope () 0)
// (defun main () ((unwrap havel nope) (cdr (cons 3 (cons 12 (nil 0))))))

(defun ((mapyes F) (List T)) (l) (Some (cons (F (car l)) (cdr l))))
(defun ((mapno F T)) () (nil (infer (F ((zero T))))))
(defun ((map F) (Option (List T))) (l) ((unwrap (mapyes F) (mapno F T)) l))
(defun ((map F) (List T)) (l) ((map F) (Some l)))

(defun range (n) (if n (Some (cons n (range (sub n 1)))) (nil 0)))

(defun main () ((unwrap havel nope) (cdr (cdr (range (sub 102 32))))))

