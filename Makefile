output.s: compiler.py
	python3 compiler.py > output.s

a.out: output.s
	gcc output.s

test: 
	./a.out ; echo $$?
