#ifndef PRELUDE
#define PRELUDE

//todo stack structs

#define STRUCT2(NAME, ARG1, ARG2, ARG1NAME, ARG2NAME)              \
(defun (NAME ARG1 ARG2) (a b) ((cast NAME) (cons_ ((cast I64) a) (cons_ ((cast I64) b) 0))))            \
(defun (ARG1NAME NAME) (n) (car ((cast (List ARG1)) n)))           \
(defun (ARG2NAME NAME) (n) (car (cdr ((cast (List ARG2)) n))))

#define TRUE 1
#define FALSE 0

(header ((cast Y) X) Y)
(header (sub I64 I64) I64)
(backend asm Instr sub)
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
(defun ((reduce F) (List T) O ) (l o) (if l
				       (F (car l) ((reduce F) (cdr l) o))
				       o
				       ))

(defun ((. F) A) (a) (F a))
(defun ((. F) (List A)) (l)
  (if l
    (cons ((. F) (car l)) ((. F) (cdr l)))
    (nil (infer ((. F) (car l))))))


(defun ((. F) (List A) B) (a b) (if a 
					    (cons ((. F) (car a) b) ((. F) (cdr a) b))
					    (nil (infer ((. F) ((nilptr A)) b)))))

(defun ((. F) A (List B)) (a b) (if b 
					    (cons ((. F) a (car b)) ((. F) a (cdr b)))
					    (nil (infer ((. F) a (car b))))))

(defun ((. F) (List A) (List B)) (a b)
	  (cons 
	    ((. F) (car a) (car b)) 
	    (if (cdr a)
	        (if (cdr b) 
		    ((. F) (cdr a) (cdr b) )
		    ((. F) (cdr a) b))
		(if (cdr b)
		    ((. F) a (cdr b))
		    (nil (infer ((. F) (car a) (car b))))))))
(defun ((. F) A B) (a b) (F a b))

(defun (cat (List T) (List T)) (a b) (cat_impl (reverse a) b))

(defun - (x) (sub 0 x))


(defun (- I64 I64) (a b) (sub a b))
(defun (+ I64 I64) (a b) (sub a (sub 0 b)))
(defun (mul_pos T T) (a b) 
  (if (!= a 0) 
      (+ b (* (- a 1) b)) 
      ((zero T))))
(defun (* T T) (a b) (if (= (sign a) 100)
			   (if (= (sign b) 100)
			       (mul_pos a b)
			       (- (mul_pos a (- 0 b))))
			   (if (= (sign b) 100)
			       (- 0 (mul_pos (- 0 a) b))
			       (mul_pos (- 0 a) (- 0 b)))))
			   
(defun (abs I64) (x) (if (= (sign x) 100) x (- 0 x)))
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

(defun range (n) 
  (if n 
      (cons n (range (- n 1))) 
      (nil 0)))

(defun (sum (List T)) (l) (if l (+ (car l) (sum (cdr l))) ((zero T))))
(defun (reverse_impl (List T) (List T)) (l acc) (if l (reverse_impl (cdr l) (cons (car l) acc)) acc))
(defun (reverse T) (l) (reverse_impl l ((nilptr  T))))
(defun (printdigits I64) (x) (+ 
			 (if (divide x 10) (printdigits (divide x 10)) 0)
			 (print_ (+ 48 (mod x 10)))  
		))
(defun (print I64) (x) (do 
			 (if (= (sign x) 101) (print_ 45) 0)
			 (printdigits (abs x)) 
			 (print_ 32)))
(defun (print (List T)) (t) (do 
			      (print_ 40) 
			      ((map print) t) 
			      (print_ 41)
			      (print_ 10)
			      ))

(defun (print String) (s) (do ((map print_) ((cast (List I64)) s)) 0))

#endif
