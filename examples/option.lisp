(header ((cast Y) X) Y)
(header (sub I64 I64) I64)
(backend asm Instr sub)
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


(defun ((@ F G) X) (x) (F (G x)))
(defun ((@ F G H) X) (x) (F (G (H x))))
(defun ((@ F G H I) X) (x) (F (G (H (I x)))))

(defun ((@ F G)) () (F (G)))
(defun ((@ F G H)) () (F (G (H))))
(defun ((@ F G H I)) () (F (G (H (I)))))


(defun ((mapyes F) (List T)) (l) (Some (cons (F (car l)) ((map F) (cdr l)))))
(defun ((map F) (Option (List T))) (l) 
  ((unwrap 
     (mapyes F) 
     (@ nil infer F (zero T))
     )
   l))

(defun (+ I64 I64) (a b) (sub a (sub 0 b)))
(defun (- I64 I64) (a b) (sub a b))
(defun (* T T) (a b) 
  (if (!= a 0) 
      (+ b (* (- a 1) b)) 
      ((zero T))))
(defun = (a b) (if (- a b) 0 1))
(defun != (a b) (if (= a b) 0 1))
(defun sign_impl  (x minx) 
  (if (= x 0) 
    100 
    (if (= minx 0) 
        101 
	(sign_impl (- x 1) (- minx 1)))))

(defun sign  (x) (sign_impl x (- 0 x)))
(defun mod (num div) (if (= (sign (- num div)) 100) (mod (- num div) div) num))

(defun divide (num div) (if (= (sign (- num div)) 100)
			    (+ 1 (divide (- num div) div))
			    0))

(defun ((filter F) (Option (List T))) (l) 
  (if l 
      (if (F (car l)) 
	  (cons (car l) ((filter F) (cdr l))) 
	  ((filter F) (cdr l))) 
      ((nilptr (List T)))))


(defun ((map F) (List T)) (l) ((map F) (Some l)))

(defun range (n) (if n (Some (cons n (range (- n 1)))) (nil 0)))

//(defun main () ((unwrap 
//		  (@ print_ car)  
//		  (zero I64)) 
//		(cdr (cdr (range (- 102 32))))))

(defun (printdigits I64) (x) (do
			 (if (divide x 10) (printdigits (divide x 10)) 0)
			 (print_ (+ 48 (mod x 10)))  
		))
(defun (print I64) (x) (do (printdigits x) (print_ 32)))

(defun main () ((map print) (range 100)))


