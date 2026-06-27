#include "prelude.lisp"

(header ((cast X) Y) Y)

(header ((struct A) A) (struct1 A))
(header ((struct A B) A B) (struct A B))
(header ((struct A B C) A B C) (struct A B C))

(header (:0 (struct A)) A)
(header (:0 (struct A B)) A)
(header (:0 (struct A B C)) A)

(header (:1 (struct A B)) B)
(header (:1 (struct A B C)) B)

(header (:2 (struct A B C)) C)


(print_ (:2 ((struct I64 I64 I64) 1 2 3)))

