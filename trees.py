import string

def match(tree, pattern, environ):
    if type(pattern) == str and pattern.upper() == pattern and pattern.isalpha():
        if pattern in environ:
            if environ[pattern] == tree:
                return environ
            else:
                return False
        else:
            return environ | {pattern: tree} 
    elif type(pattern) == tuple:
        if type(tree) == tuple:
            leftmatch = match(tree[0], pattern[0], environ)
            if leftmatch is False:
                return False
            rightmatch = match(tree[1], pattern[1], leftmatch)
            if rightmatch is False:
                return False
            return rightmatch
        else:
            return False
    elif pattern == tree:
        return environ
    return False

def subset(a, b):
    a = cons_lists(a)
    b = cons_lists(b)
    ret = match(a, b, {})
    if ret is False:
        return False
    return {q: uncons(r) for q, r in ret.items()}

def uncons(x):
    if x == "zILCH":
        return ()
    if type(x) == tuple:
        return (uncons(x[0]),) + uncons(x[1])
    return x

def cons_lists(x):
    if type(x) == list or type(x) == tuple:
        if len(x) == 0:
            return "zILCH"
        return (cons_lists(x[0]), cons_lists(x[1:]))
    return x

def substitute(tree, env):
    if type(tree) == tuple:
        return tuple(substitute(t, env) for t in tree)
    if tree in env:
        return env[tree]
    return tree

if __name__ == "__main__":

    print(cons_lists(["A", "B", "C"]))

    list_constr = cons_lists(["List", "T", ["List", "T"]])

    cons_ = cons_lists(["cons", "T", ["List", "T"]])

    cons_nil = cons_lists(["cons", "T", ["Nil", "T"]])




    print(subset(cons_lists(["cons", "MyInt64", ["Nil", "MyInt64"]]), list_constr))
    print(subset(cons_lists(["cons", "MyInt64", ["Nil", "MyInt64"]]), cons_))
    print(subset(cons_lists(["cons", "MyInt64", ["Nil", "MyInt64"]]), cons_nil))



    
