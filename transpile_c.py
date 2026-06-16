import parse
prelude = """
#include "stdio.h"
#include "lib.h"
long sub(long a, long b) {return a - b;}
long cells[100000000];
long* bump = cells;
long  cons_(long a, long b) {
   long* ret = bump;
   bump += 2;
   ret[0] = a;
   ret[1] = b;
   return (long) ret;
   }
long  car_(long a) {return ((long*)a)[0];}
long  cdr_(long a) {return ((long*)a)[1];}
long  and(long a, long b) {return a & b;}
long  imul(long a, long b) {return a * b;}
long  shr(long a, long b) {return ((unsigned long) a) >> ((unsigned long) b);}
long  print_(long a) {
    printf("%c", (char) a);
    return 0;
    }
long read_() {

   int ret = getchar();
   if (ret == EOF) {
   return 0;
   }
   return (long) ret;
}

"""
print(prelude)


program = parse.get_program()

def jsprint(expr):
    if len(expr) == 0:
        return expr
    if type(expr) == str:
        if (expr == "char"):
            return "character_lmao"
        return expr
    if expr[0] == "if":
        return jsprint(expr[1]) + " ? " + jsprint(expr[2]) + " : " + jsprint(expr[3])
    return expr[0] + "(" + ", ".join(jsprint(e) for e in expr[1:]) + ")"
for p in program:
    if p[0] == "defun":
        ret = "int" if p[1] == "main" else "long"
        print ( ret + " " + p[1] + "(" + ("long " if p[2] else "") + ", long ".join(map(jsprint, p[2])) + ");")

for p in program:
    if p[0] == "defun":
        ret = "int" if p[1] == "main" else "long"
        print ( ret + " " + p[1] + "(" + ("long " if p[2] else "") + ", long ".join(map(jsprint, p[2])) + ") { return " +     jsprint(p[3]) + ";}")
    if p[:3] == ("backend", "asm", "Linked"):
        print("long " + p[3] + "(" + ",".join(f"long a{i}" for i in range(int(p[4]))) + ") {return " + p[3] + "_(" + ",".join(f"a{i}" for i in range(int(p[4]))) + ");}") 

