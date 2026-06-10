import parse
prelude = """
function sub(a, b) {return a - b}
function cons_(a, b) {return [a, b]}
function car_(a) {
assert(typeof(a) == typeof([]))
return a[0]
}
function cdr_(a) {return a[1]}
function and(a, b) {return a & b}
output = ""
function print_(a) {
if (a == 10) {
console.log(output);
output = "";
} else {
output = output + String.fromCharCode(a); 
}
return 0}
let fs = require('fs')
let assert = require('assert')

function read_() {
  let buffer = Buffer.alloc(1)
  fs.readSync(0, buffer, 0, 1)
  return buffer[0]
}

main()
console.log(output);
"""
print(prelude)


program = parse.get_program()

def jsprint(expr):
    if len(expr) == 0:
        return expr
    if type(expr) == str:
        return expr
    if expr[0] == "if":
        return jsprint(expr[1]) + " ? " + jsprint(expr[2]) + " : " + jsprint(expr[3])
    return expr[0] + "(" + ", ".join(jsprint(e) for e in expr[1:]) + ")"

for p in program:
    if p[0] == "defun":
        #print(p)
        print ( "function " + p[1] + "(" + ",".join(p[2]) + ") { return " + 
    jsprint(p[3]) + ";}")

