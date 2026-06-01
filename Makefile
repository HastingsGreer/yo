.DELETE_ON_ERROR:

prog.in: $(SRC)
	cpp $(SRC) > prog.in

prog.IR: prog.in monomorphize.py
	python3 monomorphize.py prog.in > prog.IR

prog.IR.fast: prog.IR eliminator.py
	python3 eliminator.py prog.IR > prog.IR.fast

prog.s: compiler.py prog.IR.fast
	python3 compiler.py prog.IR > prog.s

prog: prog.s
	gcc prog.s -o prog

test: prog
	./prog; echo

mactest: prog.s
	podman run --rm --platform linux/amd64 -v "$$PWD":/work -w /work docker.io/library/gcc:latest sh -c "gcc prog.s -o prog; ./prog"
