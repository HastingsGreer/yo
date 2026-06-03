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
        if len(pattern) == 0:
            if len(tree) == 0:
                return environ
            else:
                return False
        if len(tree) == 0:
            return False
        
        if type(tree) == tuple:
            leftmatch = match(tree[0], pattern[0], environ)
            if leftmatch is False:
                return False
            rightmatch = match(tree[1:], pattern[1:], leftmatch)
            if rightmatch is False:
                return False
            return rightmatch
        else:
            return False
    elif pattern == tree:
        return environ
    return False

def subset(a, b):
    return match(a, b, {})

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



    
