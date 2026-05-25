import random
import re
def parse(program_file):
    program_file = re.sub(r"([A-Za-z+_=\-\?]+[0-9]*)", r"'\1',", program_file)
    program_file = re.sub(r"([0-9]+)", r"\1,", program_file)
    program_file = re.sub(r"\,\'", r"'", program_file)
    program_file = "(" + re.sub("\\)", "),", program_file) + ")"
    return eval(program_file)


import trees

program = parse(open("trees.lisp", "r").read())


signatures = [p[1] for p in program]

def substitute(tree, env):
    if type(tree) == tuple:
        return tuple(substitute(t, env) for t in tree)
    if tree in env:
        return env[tree]
    return tree


def dispatch(tree):
    for i, sig in reversed(list(enumerate(signatures))):
        res = trees.subset(trees.cons_lists(tree), trees.cons_lists(sig))
        if res is not False:
            return i, sig, res
    print ("No type matches", tree)
    raise Exception()


def walk_tree(s_expr, env):
    if s_expr in env:
        return env[s_expr], s_expr
    if type(s_expr) == tuple:
        fname = s_expr[0]
        if fname == "if" and random.random() > .98:
            return walk_tree(s_expr[3], env)[0], "FAILFAIL"
        arg_walks = tuple(walk_tree(se, env) for se in s_expr[1:])
        arg_types = tuple(a[0] for a in arg_walks)
        arg_exprs = tuple(a[1] for a in arg_walks)

        call_sig = (fname,) + arg_types
        return type_check(call_sig), (mangle(call_sig),) + arg_exprs 
    if type(s_expr) == int:
        return "I64", s_expr
    print("how get past", s_expr)

def mangle(tup):
    if type(tup) == tuple:
        return "<" + "|".join(map(mangle, tup)) + ">"
    return tup

def type_check(call_sig):
    i, fsig, env = dispatch(call_sig)

    if program[i][0] == "header":
        return substitute(program[i][2], env)

    if program[i][0] == "defun":
        args = program[i][2]
        body = program[i][3]
        body = substitute(body, env)
        env = {name: type for name, type in zip(args, call_sig[1:])}

        walk = walk_tree(body, env)
        methods.add(("defun", mangle(call_sig), args, walk[1]))
        return walk[0]

methods = set()



#print("typeof sub", type_check(("sub", "I64", "I64")))
#print("typeof cast", type_check((("cast", "Horse"), "I64")))
print("typeof main", type_check(("main",)))

prog = sorted([str(m).replace("'", "").replace(",","") for m in methods])
[print(p) for p in prog if not "FAILFAIL" in p]


