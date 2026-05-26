.DELETE_ON_ERROR:

prog.IR: $(SRC) types3.py
	python3 types3.py $(SRC) > prog.IR

prog.s: compiler.py prog.IR
	python3 compiler.py prog.IR > prog.s

prog: prog.s
	gcc prog.s -o prog

test: prog
	./prog; echo
