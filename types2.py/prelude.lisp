#ifndef PRELUDE
#define PRELUDE

#define STRUCT2(NAME, ARG1, ARG2, ARG1NAME, ARG2NAME)              \
(defun (NAME ARG1 ARG2) (a b) ((cast NAME) (pair a b)))            \
(defun (ARG1NAME NAME) (n) (car ((cast (List ARG1)) n)))           \
(defun (ARG2NAME NAME) (n) (car (cdr ((cast (List ARG2)) n))))

#define TRUE 1
#define FALSE 0

(header ((cast Y) X) Y)
(header (sub I64 I64) I64)
(header (infer T) T)
(header (cons_ I64 I64) I64)
(header (car_ I64) I64)
(header (print_ I64) I64)
(header (cdr_ I64) I64)
(header (if I64 T T) T)
(header (if (List Q) T T) T)

(defun (do X Y) (x y) y)
(defun (do A X Y ) (a x y) y)
(defun (do B A X Y ) (b a x y) y)

(defun ((nilptr T)) () ((cast T) 0))
(defun ((zero I64)) () ((cast I64) 0))
(defun (nil T) (x) ((nilptr (List T))))
(defun ((nil T)) () ((nilptr (List T))))

(defun (cons T (List T)) (e l) ((cast (List T)) (cons_ ((cast I64) e) ((cast I64) l)))) 
(defun (car (List T)) (l) ((cast T) (car_ ((cast I64) l))))
(defun (cdr (List T)) (l) ((cast (List T)) (cdr_ ((cast I64) l))))

(defun (sing T) (a) (cons a ((nil T))))
(defun (pair T T) (a b) (cons a (cons b ((nil T)))))
(defun (triple T T T) (a b c) (cons a (cons b (cons c ((nil T))))))
(defun (quad T T T T) (a b c d) (cons a (cons b (cons c (cons d ((nil T)))))))

(defun ((map F) (List T)) (l) 
  (if l 
      (cons (F (car l)) ((map F) (cdr l))) 
      (nil (infer (F ((nilptr T)))))))

(defun ((filter F) (List T)) (l) 
  (if l 
      (if (F (car l)) 
	  (cons (car l) ((filter F) (cdr l))) 
	  ((filter F) (cdr l))) 
      ((nilptr (List T)))))

(defun (add I64 I64) (a b) (sub a (sub 0 b)))
(defun (mul T T) (a b) 
  (if (neq a 0) 
      (add b (mul (sub a 1) b)) 
      ((zero T))))
(defun eq (a b) (if (sub a b) 0 1))
(defun neq (a b) (if (eq a b) 0 1))
(defun sign_impl  (x minx) 
  (if (eq x 0) 
    100 
    (if (eq minx 0) 
        101 
	(sign_impl (sub x 1) (sub minx 1)))))

(defun sign  (x) (sign_impl x (sub 0 x)))
(defun mod (num div) (if (eq (sign (sub num div)) 100) (mod (sub num div) div) num))

(defun divide (num div) (if (eq (sign (sub num div)) 100)
			    (add 1 (divide (sub num div) div))
			    0))

(defun range (n) 
  (if n 
      (cons n (range (sub n 1))) 
      (nil 0)))

(defun (sum (List T)) (l) (if l (add (car l) (sum (cdr l))) ((zero T))))
(defun (reverse_impl (List T) (List T)) (l acc) (if l (reverse_impl (cdr l) (cons (car l) acc)) acc))
(defun (reverse T) (l) (reverse_impl l ((nilptr  T))))
(defun (printdigits I64) (x) (add 
			 (if (divide x 10) (printdigits (divide x 10)) 0)
			 (print_ (add 48 (mod x 10)))  
		))
(defun (print I64) (x) (add (printdigits x) (print_ 32)))
(defun (print (List T)) (t) (do 
			      (print_ 40) 
			      ((map print) t) 
			      (print_ 41)
			      (print_ 32)
			      ))

#endif
