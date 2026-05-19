(defun range (n) (if n (cons n (range (sub n 1))) 0))
(defun printmap (L) (if L (cons (print (car L)) (printmap (cdr L))) 0))
(defun reverse_impl (L acc) (if L (reverse_impl (cdr L) (cons (car L) acc)) acc))
(defun reverse (L) (reverse_impl L 0))
(defun eq (a b) (if (sub a b) 0 1))
(defun sign_impl (x minx) 
  (if (eq x 0) 
    100 
    (if (eq minx 0) 
      101 
      (sign_impl (sub x 1) (sub minx 1)))))
(defun sign (x) (sign_impl x (sub 0 x)))
(defun mod (num div) (if (eq (sign (sub num div)) 100) (mod (sub num div) div) num))

(defun mul (a b) (if a (add b (mul (sub a 1) b)) 0))

(defun prime_impl (prime test) (if (sub test 1) (if (mod prime test) (prime_impl prime (sub test 1)) 0) 1))
(defun isprime (p) (if (sub p 1) (prime_impl p (sub p 1)) 0))

(defun primefilt (L) 
  (if L 
    (if (isprime (car L)) 
      (cons (car L) (primefilt (cdr L))) 
      (primefilt (cdr L))) 
    0))

(defun main () (printmap (primefilt (range 500))))
