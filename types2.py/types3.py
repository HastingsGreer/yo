import sys
import random
import re
def parse(program_file):
    program_file = re.sub(r"([A-Za-z+_=\-\?]+[0-9]*)", r"'\1',", program_file)
    program_file = re.sub(r"([0-9]+)", r"\1,", program_file)
    program_file = re.sub(r"\,\'", r"'", program_file)
    program_file = "(" + re.sub("\\)", "),", program_file) + ")"
    return eval(program_file)


import trees

program = parse(open(sys.argv[1], "r").read())

def compile_error(string):
    print(string, file=sys.stderr)
    sys.exit(1)

def expand_sig(p):
    if type(p[1]) == str:
        return (p[1],) + ("A", "B", "C", "D")[:len(p[2])]
    return p[1]
signatures = [expand_sig(p) for p in program]


def substitute(tree, env):
    if type(tree) == tuple:
        return tuple(substitute(t, env) for t in tree)
    if tree in env:
        return env[tree]
    return tree


def dispatch(tree, caller):
    for i, sig in reversed(list(enumerate(signatures))):
        res = trees.subset(trees.cons_lists(tree), trees.cons_lists(sig))
        if res is not False:
            return i, sig, res
    print("caller was", caller)
    compile_error("No type matches" + str(tree))



def walk_tree(s_expr, env, caller=None):
    if s_expr in env:
        return env[s_expr], s_expr
    if type(s_expr) == tuple:
        fname = s_expr[0]
        if fname == "if" and random.random() > .7:
            return walk_tree(s_expr[2], env)[0], "FAILFAIL"
        if fname == "if" and random.random() > .5:
            return walk_tree(s_expr[3], env)[0], "FAILFAIL"
        arg_walks = tuple(walk_tree(se, env) for se in s_expr[1:])
        arg_types = tuple(a[0] for a in arg_walks)
        arg_exprs = tuple(a[1] for a in arg_walks)

        call_sig = (fname,) + arg_types
        return type_check(call_sig, caller), (mangle(call_sig),) + arg_exprs 
    if type(s_expr) == int:
        return "I64", s_expr
    compile_error("Don't know how to walk" + s_expr)

def mangle(tup):
    if type(tup) == tuple:
        return "x$" + "$_".join(map(mangle, tup)) + "$__"
    return tup

memo = {}
def type_check(call_sig, caller=None):
    if call_sig in memo:
        return memo[call_sig]
    i, fsig, env = dispatch(call_sig, caller)

    if program[i][0] == "header":
        return substitute(program[i][2], env)

    if program[i][0] == "defun":
        args = program[i][2]
        body = program[i][3]
        body = substitute(body, env)
        env = {name: type for name, type in zip(args, call_sig[1:])}

        walk = walk_tree(body, env, caller=body)
        #print(walk[1], file=sys.stderr)
        if not "FAILFAIL" in str(walk[1]):
            memo[call_sig] = walk[0]
        methods.add(("defun", mangle(call_sig), args, walk[1]))
        return walk[0]

methods = set()
def remove_casts_infer(s_expr):
    remap_dict = {
        "x$sub$_I64$_I64$__": "sub",
        "x$car_$_I64$__": "car",
        "x$cdr_$_I64$__": "cdr",
        "x$cdr_$_I64$__": "cdr",
        "x$cons_$_I64$_I64$__": "cons",
        "x$print_$_I64$__": "print",
        }
    if type(s_expr) == tuple and len(s_expr) > 0:
        s_expr = list(s_expr)
        if type(s_expr[0]) == str:
            if "cast" in s_expr[0]:
                return remove_casts_infer(s_expr[1])
            if "infer" in s_expr[0]:
                return 0
            if s_expr[0][:5] == "x$if$":
                s_expr[0] = "if"
            if s_expr[0] in remap_dict:
                s_expr[0] = remap_dict[s_expr[0]]
            return (s_expr[0],) + tuple(remove_casts_infer(t) for t in s_expr[1:])
    if type(s_expr) == str and s_expr == "x$main$__":
        return "main"
    return s_expr

again = 1
while again:
   memo = {}
   type_check(("main",))
   n_methods = len(set(m[1] for m in methods))
   n_filled = len(set(m[1] for m in methods if not "FAILFAIL" in str(m[3])))
   again = n_methods != n_filled


prog = sorted([str(remove_casts_infer(m)).replace("'", "").replace(",","") for m in methods])
[print(p) for p in prog if not "FAILFAIL" in p]


