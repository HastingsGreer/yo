.DELETE_ON_ERROR:

prog.in: $(SRC)
	cpp $(SRC) > prog.in

prog.IR: prog.in types3.py
	python3 types3.py prog.in > prog.IR

prog.s: compiler.py prog.IR
	python3 compiler.py prog.IR > prog.s

prog: prog.s
	gcc prog.s -o prog

test: prog
	./prog; echo
