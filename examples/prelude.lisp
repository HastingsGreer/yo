#ifndef PRELUDE
#define PRELUDE

//todo stack structs

(defun (read) () (Char (read_)))
(defun readall_impl (char) (if char (cons char (readall_impl (read))) (nil (Char 0) )))

(defun ((then T)) () ((cast (ThenClause T)) 0))
(defun ((then A B)) () ((cast (ThenClause A B)) 0))
(defun ((then A B C)) () ((cast (ThenClause A B C)) 0))
(defun ((then A B C D)) () ((cast (ThenClause A B C D)) 0))
(defun ((then A B C D E)) () ((cast (ThenClause A B C D E)) 0))
(defun ((then A B C D E F)) () ((cast (ThenClause A B C D E F)) 0))
(defun ((then A B C D E F G)) () ((cast (ThenClause A B C D E F G)) 0))
(defun ((then A B C D E F G H)) () ((cast (ThenClause A B C D E F G H)) 0))
(defun ((then A B C D E F G H I)) () ((cast (ThenClause A B C D E F G H I)) 0))
(defun ((let NAME) ARGTYPE (ThenClause BODY)) (NAME _) BODY)
(defun ((let NAMEONE NAMETWO) ARGTYPEONE ARGTYPETWO  (ThenClause BODY)) (NAMEONE NAMETWO _) BODY)
(defun ((let NAMEONE NAMETWO NAMETHREE) ARGTYPEONE ARGTYPETWO ARGTYPETHREE (ThenClause BODY)) (NAMEONE NAMETWO NAMETHREE _) BODY)
(defun readall () (String (readall_impl (read))))

(defun in (thing collection) (if collection (if (= thing (car collection)) 1 (in thing (cdr collection))) 0))
(defun len (l) (if l (+ 1 (len (cdr l))) 0))

#define STRUCT2(NAME, ARG1, ARG2, ARG1NAME, ARG2NAME)              \
(defun (NAME ARG1 ARG2) (a b) ((cast NAME) (cons_ ((cast I64) a) (cons_ ((cast I64) b) 0))))            \
(defun (ARG1NAME NAME) (n) (car ((cast (List ARG1)) n)))           \
(defun (ARG2NAME NAME) (n) (car (cdr ((cast (List ARG2)) n))))

#define STRUCT1(NAME, ARG1, ARG1NAME)              \
(defun (NAME ARG1) (a) ((cast NAME) a))            \
(defun (ARG1NAME NAME) (n) ((cast ARG1) n))           \

#define STRUCT3(NAME, ARG1, ARG2, ARG3, ARG1NAME, ARG2NAME, ARG3NAME)              \
(defun (NAME ARG1 ARG2 ARG3) (a b c) ((cast NAME) (cons_ ((cast I64) a) (cons_ ((cast I64) b) (cons_ ((cast I64) c) 0)))))            \
(defun (ARG1NAME NAME) (n) (car ((cast (List ARG1)) n)))           \
(defun (ARG2NAME NAME) (n) (car (cdr ((cast (List ARG2)) n)))) \
(defun (ARG3NAME NAME) (n) (car (cdr (cdr ((cast (List ARG3)) n)))))

#define TRUE 1
#define FALSE 0

(backend asm Linked cons_ 2)
(backend asm Linked car_ 1)
(backend asm Linked cdr_ 1)

(header ((cast Y) X) Y)
(header (sub I64 I64) I64)
(backend asm Instr sub)
(header (infer T) T)
(header (cons_ I64 I64) I64)
(header (car_ I64) I64)
(header (cdr_ I64) I64)
(header (print_ I64) I64)
(header (read_) I64)
(header (if I64 T T) T)
(header (if (List Q) T T) T)

(defun (do Y ) (y) y)
(defun (do X Y) (x y) y)
(defun (do A X Y ) (a x y) y)
(defun (do B A X Y ) (b a x y) y)
(defun (do C B A X Y ) (c b a x y) y)
(defun (do D C B A X Y ) (d c b a x y) y)

(defun ((F . G) X) (x) (F (G x)))
(defun ((F . G . H) X) (x) (F (G (H x))))
(defun ((F . G . H . I) X) (x) (F (G (H (I x)))))
(defun ((F . G . H . I . J) X) (x) (F (G (H (I (J x))))))

(defun ((F . G)) () (F (G)))
(defun ((F . G . H)) () (F (G (H))))
(defun ((F . G . H . I)) () (F (G (H (I)))))

(defun ((\ X . BODY) ARGTYPE) (X) BODY)
(defun ((\ X Y . BODY) ARGTYPE ARGTYPETWO) (X Y) BODY)
(defun ((\ X Y Z . BODY) ARGTYPE ARGTYPETWO ARGTYPETHREE) (X Y Z) BODY)
(defun ((\ X Y Z A . BODY) ARGTYPE ARGTYPETWO ARGTYPETHREE ATFOUR ) (X Y Z A) BODY)
(defun || (a b) (if a a b))
(defun || (a b c) (if a a (if b b c)))
(defun && (a b) (if a b a))
(defun && (a b c) (if a (if b c b) a))

(defun ((nilptr T)) () ((cast T) 0))
(defun ((sentinel T)) () ((cast T) 0))
(defun ((zero I64)) () ((cast I64) 0))
(defun (zero T) (_) ((zero T)))
(defun (nil T) (x) ((nilptr (List T))))
(defun ((nil T)) () ((nilptr (List T))))

(defun (cons T (List T)) (e l) ((cast (List T)) (cons_ ((cast I64) e) ((cast I64) l)))) 
(defun (car (List T)) (l) ((cast T) (car_ ((cast I64) l))))
(defun (cdr (List T)) (l) ((cast (List T)) (cdr_ ((cast I64) l))))

(defun (list T) (a) (cons a ((nil T))))
(defun (list T T) (a b) (cons a (cons b ((nil T)))))
(defun (list T T T) (a b c) (cons a (cons b (cons c ((nil T))))))
(defun (list T T T T) (a b c d) (cons a (cons b (cons c (cons d ((nil T)))))))
(defun (list T T T T T) (a b c d e) (cons a (cons b (cons c (cons d (cons e ((nil T))))))))
(defun (list T T T T T T) (a b c d e f) (cons a (cons b (cons c (cons d (cons e (cons f((nil T)))))))))

(defun (+ X Y Z) (x y z) (+ x (+ y z)))
(defun (+ X Y Z A) (x y z a) (+ x (+ y z a)))
(defun (+ X Y Z A B) (x y z a b) (+ x (+ y z a b)))
(defun (* X Y Z) (x y z) (* x (* y z)))
(defun (* X Y Z A) (x y z a) (* x (* y z a)))
(defun (* X Y Z A B) (x y z a b) (* x (* y z a b)))
(defun (* X Y Z A B C) (x y z a b c) (* x (* y z a b c)))

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

(defun zip (a b) (if (&& a b) (cons (list (car a) (car b)) (zip (cdr a) (cdr b))) (infer (list (list (car a) (car b)))))) 

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

(defun cat_impl (a b) (if a (cons (car a) (cat_impl (cdr a) b)) b))
(defun (cat (List T) (List T)) (a b) (cat_impl a b))
(defun (cat String String) (a b) (String (cat (:chars a) (:chars b))))
(defun (+ String String) (a b) (cat a b))

(defun - (x) (- 0 x))


(defun (- I64 I64) (a b) (sub a b))
(defun (+ I64 I64) (a b) (sub a (sub 0 b)))
(defun (mul_pos T T) (a b) 
  (if (!= a 0) 
      (+ b (* (- a 1) b)) 
      ((zero T))))
(defun (* T T) (a b) (if (= (negative? a) 0)
			   (if (= (negative? b) 0)
			       (mul_pos a b)
			       (- (mul_pos a (- 0 b))))
			   (if (= (negative? b) 0)
			       (- 0 (mul_pos (- 0 a) b))
			       (mul_pos (- 0 a) (- 0 b)))))
			   
(defun (abs I64) (x) (if (= (negative? x) 0) x (- 0 x)))
(defun = (a b) (if (- a b) 0 1))
(defun != (a b) (if (= a b) 0 1))
(defun not (a) (if a 0 1))
(defun negative?_impl  (x minx) 
  (if (= x 0) 
    0 
    (if (= minx 0) 
        1 
	(negative?_impl (- x 1) (- minx 1)))))

(defun negative?  (x) (negative?_impl x (- 0 x)))
(defun mod (num div) (if (= (negative? (- num div)) 0) (mod (- num div) div) num))

(defun divide (num div) (if (= (negative? (- num div)) 0)
			    (+ 1 (divide (- num div) div))
			    0))

(defun range_impl (n) 
  (if n 
      (cons (- n 1) (range_impl (- n 1))) 
      (nil 0)))
(defun range (n) (reverse (range_impl n)))

(defun sum (l) 
  (if l 
    (+ (car l) (sum (cdr l))) 
    (zero (infer (car l)))))
(defun (sum (List (List T))) (l) (sum ((map sum) l)))
(defun (reverse_impl (List T) (List T)) (l acc) (if l (reverse_impl (cdr l) (cons (car l) acc)) acc))
(defun (reverse T) (l) (reverse_impl l ((nilptr  T))))
(defun (printdigits I64) (x) (+ 
			 (if (divide x 10) (printdigits (divide x 10)) 0)
			 (print_ (+ 48 (mod x 10)))  
		))
(defun (print I64) (x) (do 
			 (if (= (negative? x) 1) (print_ 45) 0)
			 (printdigits (abs x)) 
			 ))
(defun printsp (x) (do (print x) (print " ")))
(defun (print (List T)) (t) (do 
			      (print_ 40) 
			      ((map printsp) t) 
			      (print_ 41)
			      (print_ 10)
			      ))

(header (if Char T T) T)
(header (if String T T) T)
STRUCT1(Char, I64, :charcode)
STRUCT1(String, (List Char), :chars)

(defun (car String) (s) (car (:chars s))) 
(defun (cdr String) (s) (String (cdr (:chars s))) )
(defun (cons Char String) (c s) (String (cons c (:chars s))))

(defun (print Char) (char) (print_ (:charcode char)))
(defun (= Char Char) (a b) (= (:charcode a) (:charcode b)))
(defun (= String Char) (s c) 
  (if (= (len s) 1) 
      (= (:charcode (car (:chars s))) (:charcode c)) 
      0))
(defun (= Char String) (c s) (= s c))
(defun (= String String) (a b) 
  (if a
    (if b
      (if (= (car a) (car b))
	(= (cdr a) (cdr b))
	0)
      0)
    (if b
      0
      1)))

(defun (print String) (s) (do 
			    ((map print) (:chars s)) 0))
(defun println (x) (do (print x) (print "\n")))


#endif
