import parse

program = parse.get_program()
mungemap = {}
def munge(name):
    if not "<" in name:
        return name
    if name in mungemap:
        return mungemap[name]
    mungemap[name] = "m" + str(len(mungemap))
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


def inline(program):
    for i, definition in enumerate(program):
        if definition[0] == "defun":
            defun, name, args, body = definition
            if not (contains(body, "if")):
                oneone = True
                for c in args:
                    if contains(body, c) != 1:
                        oneone = False
                if oneone:
                    print(definition)


#going = True
#while going:
#    going, program = inline(program)
#inline(program)

            
[print(parse.lispprint(p)) for p in program]


            
