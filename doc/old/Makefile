fib.s: compiler.py fib.lisp
	python3 compiler.py fib.lisp > fib.s

fib: fib.s
	gcc fib.s -o fib

fibtest: fib
	./fib; echo


primes.s: compiler.py primes.lisp
	python3 compiler.py primes.lisp > primes.s

primes: primes.s
	gcc primes.s -o primes

primestest: primes
	./primes; echo
