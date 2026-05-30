#include <stdio.h>
void* cons(void* a, void* b) {
	long* ret = malloc(16);
	*ret = a;
	*(ret + 1) = b;
	return ret;
}

void* car(long* a) {
	return *a;
}

void print(long x) {
	printf("%li ", x);
}
