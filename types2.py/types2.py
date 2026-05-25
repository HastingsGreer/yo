from dataclasses import dataclass

@dataclass
class StructName:
    name: str
    nargs: int

    def __eq__(self, other):
        if self.name == other.name:
            assert self.nargs == other.nargs
            return True
        return False



@dataclass
class Struct:
    name: StructName
    args: []

class Tuple:
    args: []

@dataclass
class Where:
    typevar: Typevar
    elem

@dataclass
class Typevar:
    name: str



List = StructName("List", 1)
Integer = Struct(StructName("Integer", 0), [])

ints = Struct(List, [Integer])

T = Typevar("T")
anylist = Where(T, Struct(List, T))

def subtype(lower, upper):
    if type(upper) == Struct == type(lower):
        if lower.name != upper.name:
            return False
        for i in range(lower.name.nargs):
            if not subtype(lower.args[i], upper.args[i], env):
                return False
            if not subtype(upper.args[i], lower.args[i], env):
                return False
        return True
    if type(lower) == Tuple == type(upper):
        if len(lower.args) != len(upper.args):
            return False
        for i in range(len(lower.args)):
            if not subtype(lower.args[i], upper.args[i]):
                return False
        return True
    if type(upper

    return False
    

    print(lower)
    print(upper)

print(subtype(ints, anylist))







