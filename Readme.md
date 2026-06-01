
yo is an experimental statically compiled, multiple dispatch Lisp. Where most lisps are homoiconic between code and values, yo is homoiconic between code and types. 

Concrete types in yo are nested lists of strings, like (List (List I64)) for a list of lists of integers. Every value in yo has a concrete type.

Abstract types in yo are denoted by nested lists of strings, some of which may be type variables. Type variables are simply strings consisting entirely of captital letters. Abstract types are conceptually sets of concrete types; specifically all matching concrete types. 

For example, the abstract type (List T) matches (List (List I64)) via the assignment {T: (List I64)}

The name of every function in yo is an abstract type. An s-expression dispatches to a function as follows: first, for every term except the first, the terms are replaced by their return types. This results in a concrete type, the caller type. Then, the most specific function name that contains the caller type is found, and that function is called.


Hello world is 

```
#include "prelude.lisp"
(defun main () (print "Hello World!"))
```

Lets walk through the call to print. 

First, to find the caller type, the second term, "Hello World!", is replaced with its return type, String.

```
(print String)
```

then, the most specific function name containing this type is found. This is in the prelude:

```
(defun (print String) (s) (do ((map print_) ((cast (List I64)) s)) 0))
```

As the abstract type `(print String)` has no type variables, it only contains one concrete type, so it is most specific. Therefore, this is the function that is called.


Run it with 

```
make SRC="examples/helloworld.lisp" test
```

Yo code that uses cast _implicitly_ declares contracts, yo code that doesn't use cast is sound if the contracts declared by cast are correct.
