.DELETE_ON_ERROR:

prog.in: $(SRC)
	cpp $(SRC) > prog.in

prog.IR: prog.in monomorphize.py
	python3 monomorphize.py prog.in > prog.IR

prog.IR.fast: prog.IR eliminator.py
	python3 eliminator.py prog.IR > prog.IR.fast

prog.s: compiler.py prog.IR.fast
	python3 compiler.py prog.IR.fast > prog.s

examples/lib.o: examples/lib.c
	gcc -o examples/lib.o -c examples/lib.c

prog: prog.s examples/lib.o
	gcc prog.s examples/lib.o -o prog

test: prog
	./prog; echo

mactest: prog.s
	podman run --rm --platform linux/amd64 -v "$$PWD":/work -w /work docker.io/library/gcc:latest sh -c "gcc prog.s -o prog; ./prog"
