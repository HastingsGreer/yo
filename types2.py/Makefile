.DELETE_ON_ERROR:

prog.IR: trees.lisp
	python3 types3.py > prog.IR

prog.s: compiler.py prog.IR
	python3 compiler.py prog.IR > prog.s

prog: prog.s
	gcc prog.s -o prog

test: prog
	./prog; echo
