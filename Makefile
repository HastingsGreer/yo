output.s: compiler.py fib.lisp
	python3 compiler.py > output.s

a.out: output.s
	gcc output.s

test: a.out
	./a.out; echo
