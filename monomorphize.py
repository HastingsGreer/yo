import sys
from functools import cache
import random
import re
    
import parse
import trees

def lispprint(tup):
    return str(tup).replace("'", "").replace(",","")

def compile_error(string):
    print(string, file=sys.stderr)
    sys.exit(1)

def expand_sig(p):
    if type(p[1]) == str:
        return (p[1],) + ("A", "B", "C", "D")[:len(p[2])]
    return p[1]

program = parse.get_program()

signatures = [expand_sig(p) for p in program]

def substitute(tree, env):
    if type(tree) == tuple:
        return tuple(substitute(t, env) for t in tree)
    if tree in env:
        return env[tree]
    return tree

@cache 
def dispatch_impl(tree):
    candidates = []
    for i, sig in reversed(list(enumerate(signatures))):
        res = trees.subset(tree, sig)
        if res is not False:
            candidates.append((i, sig, res))
    specific = []
    if len(candidates) != 1:
        for i in range(len(candidates)):
            chosen = candidates[i]
            valid = True
            for j in range(len(candidates)):
                if i != j:
                    c = candidates[j]
                    c_subtype_of_chosen = trees.subset(c[1], chosen[1]) is not False 
                    if c_subtype_of_chosen:
                        valid = False
            if valid:
                specific.append(chosen)
        return candidates, specific
    return candidates, candidates

@cache
def dispatch(tree, error_info):
    candidates, specific = dispatch_impl(tree)
    if len(candidates) == 0:
        compile_error("error_info was" + lispprint(error_info) + "\n" + 
        "No type matches" + lispprint(tree))

    if len(specific) != 1:
        for c in candidates:
            print(lispprint(c), lispprint(program[c[0]]), file=sys.stderr)
        compile_error("error_info was" + lispprint(error_info) + "\n" + 
        "No most specificic method for" + lispprint(tree))
    return specific[0]

def walk_tree(s_expr, env, error_info=None):
    if s_expr in env:
        return env[s_expr], s_expr
    if type(s_expr) == tuple:
        fname = s_expr[0]
        if fname == "if" and random.random() > .9:
            return walk_tree(s_expr[2], env)[0], "FAILFAIL"
        if fname == "if" and random.random() > .3:
            return walk_tree(s_expr[3], env)[0], "FAILFAIL"
        arg_walks = tuple(walk_tree(se, env, error_info) for se in s_expr[1:])
        arg_types = tuple(a[0] for a in arg_walks)
        arg_exprs = tuple(a[1] for a in arg_walks)

        call_sig = (fname,) + arg_types
        return_type, name = dispatch_then_instantiate(call_sig, error_info)
        return return_type, (name,) + arg_exprs 
    if s_expr.isdecimal():
        return "I64", s_expr
    print(error_info, file=sys.stderr)
    compile_error("Don't know how to walk " + s_expr)


def dispatch_then_instantiate(call_sig, error_info=None):
    if call_sig in memo:
        return memo[call_sig]
    i, fsig, env = dispatch(call_sig, error_info)

    if program[i][0] == "header":
        name = call_sig[0]
        if type(name) != str:
            name = mangle(name)
        return substitute(program[i][2], env), name

    if program[i][0] == "defun":
        args = program[i][2]
        body = program[i][3]
        body = substitute(body, env)
        argument_dict = {name: type for name, type in zip(args, call_sig[1:])}

        return_type, monomorphised_body = walk_tree(body, argument_dict,
                                error_info=(
                                    str(error_info) 
                                    + "\n function: " 
                                    + lispprint(program[i]) 
                                    + "\n    method: " 
                                    + lispprint(call_sig) + "\n"))

        name = mangle((call_sig, return_type))
        if not "FAILFAIL" in str(monomorphised_body):
            memo[call_sig] = return_type, name
        methods.add(("defun", name, args, monomorphised_body))
        return return_type, name
def mangle(tup):

    if type(tup) == tuple:
        return "<" + ":".join(map(mangle, tup)) + ">"
    def charmangle(c:str):
        if c.isalnum() or c in "$_":
            return c
        return "$$_" + str(ord(c))
    return "".join(map(charmangle, tup))

memo = {}

methods = set()

again = 1
while again:
   memo = {}
   dispatch_then_instantiate(("main",))
   n_methods = len(set(m[1] for m in methods))
   n_filled = len(set(m[1] for m in methods if not "FAILFAIL" in str(m[3])))
   again = n_methods != n_filled

def remove_casts_infer(s_expr):
    if type(s_expr) == tuple and len(s_expr) > 0:
        s_expr = list(s_expr)
        if type(s_expr[0]) == str:
            if "<cast" in s_expr[0]:
                print(s_expr[0], file=sys.stderr)
                return remove_casts_infer(s_expr[1])
            if "infer" == s_expr[0]:
                return 0
            return (s_expr[0],) + tuple(remove_casts_infer(t) for t in s_expr[1:])
    if type(s_expr) == str and "<<main>:" in s_expr:
        return "main"
    return s_expr

prog = sorted([lispprint(remove_casts_infer(m)) for m in methods])
[print(p) for p in prog if not "FAILFAIL" in p]


