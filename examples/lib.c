

long getfour_(long x) {return 4;}
double tf (long a){return *(double*) &a;}
long ff (double a){return *(long*) &a;}

long fadd_(long a, long b) {return  ff(tf(a) + tf(b));}
long fmul_(long a, long b) {return  ff(tf(a) * tf(b));}
long fdiv_(long a, long b) {return  ff(tf(a) / tf(b));}
long fcmp_(long a, long b) {return  ff(tf(a) > tf(b));}

long tofloat_(long a) {
	double ret;
	ret = a;
	return ff (ret);
}

long fromfloat_(long A) {
	long ret;
	ret = tf(A);
	return ret;
}
