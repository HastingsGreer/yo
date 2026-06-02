.DELETE_ON_ERROR:

build/$(SRC).in: $(SRC)
	cpp $(SRC) > build/$(SRC).in

build/$(SRC).IR: build/$(SRC).in monomorphize.py
	python3 monomorphize.py build/$(SRC).in > build/$(SRC).IR

build/$(SRC).IR.fast: build/$(SRC).IR eliminator.py
	python3 eliminator.py build/$(SRC).IR > build/$(SRC).IR.fast

build/$(SRC).s: compiler.py build/$(SRC).IR.fast
	python3 compiler.py build/$(SRC).IR.fast > build/$(SRC).s

build/examples/lib.o: examples/lib.c
	gcc -o build/examples/lib.o -c examples/lib.c

build/$(SRC): build/$(SRC).s build/examples/lib.o
	gcc build/$(SRC).s examples/lib.o -o build/$(SRC)

test: build/$(SRC)
	./build/$(SRC); echo

mactest: build/$(SRC).s
	podman run --rm --platform linux/amd64 -v "$$PWD":/work -w /work docker.io/library/gcc:latest sh -c "gcc build/$(SRC).s -o build/$(SRC); ./build/$(SRC)"
