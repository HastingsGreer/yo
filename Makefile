.DELETE_ON_ERROR:

build/$(SRC).in: $(SRC)
	@mkdir -p build/examples
	cpp -Wno-invalid-pp-token $(SRC) > build/$(SRC).in

build/$(SRC).IR: build/$(SRC).in monomorphize.py
	python3 monomorphize.py build/$(SRC).in > build/$(SRC).IR

build/$(SRC).IR.fast: build/$(SRC).IR eliminator.py
	python3 eliminator.py build/$(SRC).IR > build/$(SRC).IR.fast

build/$(SRC).s: compiler.py build/$(SRC).IR.fast
	python3 compiler.py build/$(SRC).IR.fast > build/$(SRC).s

build/examples/lib.o: examples/lib.c examples/lib.h
	gcc -O3 -o build/examples/lib.o -c examples/lib.c
build/examples/gc.o: examples/gc.c examples/gc.h
	gcc -O3 -o build/examples/gc.o -c examples/gc.c

build/$(SRC): build/$(SRC).s build/examples/lib.o build/examples/gc.o
	gcc build/$(SRC).s build/examples/lib.o build/examples/gc.o -o build/$(SRC)

test: build/$(SRC)
	./build/$(SRC); echo

build/examples/gc.o.mac: examples/gc.c examples/gc.h
	podman run -i --rm --platform linux/amd64 -v "$$PWD":/work -w /work docker.io/library/gcc:latest sh -c "gcc examples/gc.c -c -o build/examples/gc.o.mac"

build/examples/lib.o.mac: examples/lib.c
	podman run -i --rm --platform linux/amd64 -v "$$PWD":/work -w /work docker.io/library/gcc:latest sh -c "gcc examples/lib.c -c -o build/examples/lib.o.mac"

mactest: build/$(SRC).s build/examples/lib.o.mac build/examples/gc.o.mac
	podman run -i --rm --platform linux/amd64 -v "$$PWD":/work -w /work docker.io/library/gcc:latest sh -c "gcc build/$(SRC).s build/examples/gc.o.mac build/examples/lib.o.mac -o build/$(SRC); ./build/$(SRC)"

build/$(SRC).js: build/$(SRC).IR.fast transpile_js.py
	python3 transpile_js.py build/$(SRC).IR.fast > build/$(SRC).js

jstest: build/$(SRC).js
	node build/$(SRC).js

build/$(SRC).c: build/$(SRC).IR.fast transpile_c.py
	python3 transpile_c.py build/$(SRC).IR.fast > build/$(SRC).c

build/$(SRC).out: build/$(SRC).c build/examples/lib.o build/examples/gc.o
	gcc -O3 -flto build/$(SRC).c build/examples/lib.o build/examples/gc.o -Iexamples -o build/$(SRC).out

ctest: build/$(SRC).out
	build/$(SRC).out

