import parse
prelude = """
#include "stdio.h"
#include "lib.h"
#include "gc.h"
long sub(long a, long b) {return a - b;}
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
int main(int argc, char **argv) {
    setupgc();
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
        p = list(p)
        if (p[1] == "main"):
            p[1] = "progmain"
        p = tuple(p)
        print ( ret + " " + p[1] + "(" + ("long " if p[2] else "") + ", long ".join(map(jsprint, p[2])) + ");")

for p in program:
    if p[0] == "defun":
        ret = "int" if p[1] == "main" else "long"
        p = list(p)
        if (p[1] == "main"):
            p[1] = "progmain"
        p = tuple(p)
        print ( ret + " " + p[1] + "(" + ("long " if p[2] else "") + ", long ".join(map(jsprint, p[2])) + ") { return " +     jsprint(p[3]) + ";}")
    if p[:3] == ("backend", "asm", "Linked"):
        print("long " + p[3] + "(" + ",".join(f"long a{i}" for i in range(int(p[4]))) + ") {return " + p[3] + "_(" + ",".join(f"a{i}" for i in range(int(p[4]))) + ");}") 

