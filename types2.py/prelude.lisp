#ifndef PRELUDE
#define PRELUDE

(header ((cast Y) X) Y)
(header (sub I64 I64) I64)
(header (infer T) T)
(header (cons_ I64 I64) I64)
(header (car_ I64) I64)
(header (print_ I64) I64)
(header (cdr_ I64) I64)
(header (if C T T) T)

(defun ((nilptr T)) () ((cast T) 0))
(defun ((zero I64)) () ((cast I64) 0))
(defun (nil T) (x) ((nilptr (List T))))

(defun (cons T (List T)) (e l) ((cast (List T)) (cons_ ((cast I64) e) ((cast I64) l)))) 
(defun (car (List T)) (l) ((cast T) (car_ ((cast I64) l))))
(defun (cdr (List T)) (l) ((cast (List T)) (cdr_ ((cast I64) l))))

(defun ((map F) (List T)) (l) (if l (cons (F (car l)) ((map F) (cdr l))) (nil (infer (F ((zero T)))))))

(defun ((filter F) (List T)) (l) (if l (if (F (car l)) (cons (car l) ((filter F) (cdr l))) ((filter F) (cdr l))) ((nilptr (List T)))))

(defun add (a b) (sub a (sub 0 b)))
(defun mul (a b) (if a (add b (mul (sub a 1) b)) 0))
(defun eq (a b) (if (sub a b) 0 1))
(defun sign_impl  (x minx) (if (eq x 0) 100 (if (eq minx 0) 101 (sign_impl (sub x 1) (sub minx 1)))))
(defun sign  (x) (sign_impl x (sub 0 x)))
(defun mod (num div) (if (eq (sign (sub num div)) 100) (mod (sub num div) div) num))

(defun range  (n) (if n (cons n (range (sub n 1))) (nil 0)))

(defun (sum (List T)) (l) (if l (add (car l) (sum (cdr l))) ((zero T))))
(defun (reverse_impl (List T) (List T)) (l acc) (if l (reverse_impl (cdr l) (cons (car l) acc)) acc))
(defun (reverse T) (l) (reverse_impl l ((nilptr  T))))

#endif
