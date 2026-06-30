#include "gc.h"

long getfour_(long x) {return 4;}
double tf (long a){return *(double*) &a;}
long ff (double a){return *(long*) &a;}

long fadd_(long a, long b) {return  ff(tf(a) + tf(b));}
long fmul_(long a, long b) {return  ff(tf(a) * tf(b));}
long fdiv_(long a, long b) {return  ff(tf(a) / tf(b));}
long fcmp_(long a, long b) {return tf(a) > tf(b);}

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

Reference cstring_to_yostring_impl( char* cstring) {
	Reference ret = 0;
	char* cstring_end = cstring;
	while (*(cstring_end + 1)) {
		cstring_end ++;
	}
	while (cstring_end >= cstring) {
		ret = cons__(*cstring_end, ret);
		cstring_end -= 1;
	}
	return ret;
}
long cstring_to_yostring_(long cstring) {
	return cstring_to_yostring_impl((char*) cstring);
}

char* yostring_to_cstring_impl(Reference yostring) {
	// leaky oh no
	int length = 0;
	Reference lengthrunner = yostring;
	while (lengthrunner) {
		length += 1;
		lengthrunner = get(lengthrunner)->nextChild;
	}
	char* ret = malloc(length + 1);
	callstack_assert(ret);
	char* retrunner = ret;

	while (yostring) {

		*retrunner = get(yostring)->child;
		yostring = get(yostring)->nextChild;
		retrunner += 1;
	}
	*retrunner = 0;


	return ret;
}
long yostring_to_cstring_(long yostring) {
	return (long) yostring_to_cstring_impl(yostring);
}

char *read_file(const char *path) {
  FILE *f = fopen(path, "rb");
  callstack_assert(f);

  fseek(f, 0, SEEK_END);
  long len = ftell(f);
  rewind(f);

  char *buf = malloc(len + 1);
  if (!buf) {
    fclose(f);
    return NULL;
  }

  fread(buf, 1, len, f);
  buf[len] = '\0';
  fclose(f);
  return buf;
}
long read_cstring_from_filename_(long filename) {
	return (long) read_file((char*) filename);
}

void write_file(const char* path, const char* value) {
  FILE *f = fopen(path, "wb");
  callstack_assert(f);
  fwrite(value, 1, strlen(value), f);
  fclose(f);
}
long write_cstring_to_filename_(long cstring, long filename) {
	write_file((char*) filename, (char*) cstring);
	return 0;
}




