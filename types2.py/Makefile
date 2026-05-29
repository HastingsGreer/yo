.DELETE_ON_ERROR:

prog.in: $(SRC)
	cpp $(SRC) | grep -v // > prog.in

prog.IR: prog.in types3.py
	python3 types3.py prog.in > prog.IR

prog.s: compiler.py prog.IR
	python3 compiler.py prog.IR > prog.s

prog: prog.s
	gcc prog.s -o prog

test: prog
	./prog; echo

mactest: prog.s
	podman run --rm --platform linux/amd64 -v "$$PWD":/work -w /work docker.io/library/gcc:latest sh -c "gcc prog.s -o prog; ./prog"
