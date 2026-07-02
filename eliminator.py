import sys
import trees
import parse

program = parse.get_program()
mungemap = {}
def munge(name):
    if not "<" in name:
        return name
    if name in mungemap:
        return mungemap[name]
    mungemap[name] = "".join([a for a in name if a.isalpha()])[:14] + str(len(mungemap))

    return mungemap[name]
def mungetree(t):
    if type(t) == tuple:
        return tuple(mungetree(x) for x in t)
    return munge(t)

program = mungetree(program)


def tree_replace(tree, from_, to):
    if type(tree) == str:
        if tree == from_:
            return to
        return tree
    return tuple(tree_replace(t, from_, to) for t in tree)


def find_dup_body_replace(program):
    body_to_name = {}
    for i, definition in enumerate(program):
        if len(definition) > 2:
            if definition[2:] in body_to_name:
                program = list(program)
                del program[i]
                program = tuple(program)

                return True, tree_replace(program, definition[1], body_to_name[definition[2:]])
            body_to_name[definition[2:]] = definition[1]
    return False, program

going = True
while going:
    going, program = find_dup_body_replace(program)

#[print(parse.lispprint(p)) for p in program]

def remove_renames(program):
    for i, definition in enumerate(program):
        if definition[0] == "defun":
            defun, name, args, body = definition
            if len(args) == 1 and len(body) == 2 and type(body[0]) == str and type(body[1]) == str and body[1] == args[0]:
                program = list(program)
                del program[i]
                program = tuple(program)
                
                return True, tree_replace(program, name, body[0])
    return False, program

going = True
while going:
    going, program = remove_renames(program)

def contains(tup, key):
    if type(tup) == str:
        return tup == key
    return sum(contains(t, key) for t in tup)

def flatten(tup):
    if type(tup) == str:
        return (tup,)
    ret = ()
    for t in tup:
        ret = ret + t
    return ret

def doinline(sexpr, inlineme):
    if type(sexpr) == str:
        return sexpr
    args = [doinline(a, inlineme) for a in sexpr[1:]]
    if sexpr[0] in inlineme:
        inlined = inlineme[sexpr[0]]
        sexpr = trees.substitute(inlined[3], {iargname:arg for (iargname, arg) in zip(inlined[2], args)})
        return doinline(sexpr, inlineme)
    else:
        return (sexpr[0],) + tuple(args)


def inline(program):
    inlineme = {}
    dontreturn = set()
    for i, definition in enumerate(program):
        if definition[0] == "defun":
            defun, name, args, body = definition
            if not (contains(body, name) or name == "main"):
                oneone = True
                for c in args:
                    if contains(body, c) != 1:
                        oneone = False
                oneone = oneone and len(str(body)) < 120
                if oneone:
                    print(definition, file=sys.stderr)
                    print(contains(program, name), file=sys.stderr)
                    inlineme[name] = definition
                    dontreturn.add(i)
    ret = []
    for i, definition in enumerate(program):
        if definition[0] == "defun":
            if i not in dontreturn:
                defun, name, args, body = definition
                ret.append((defun, name, args, doinline(body, inlineme)))

        else:
            ret.append(definition)
    return ret




#going = True
#while going:
#    going, program = inline(program)
program = inline(program)
print(len(program), file=sys.stderr)

            
[print(parse.lispprint(p)) for p in program]


            
