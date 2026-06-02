import re
import sys
from dataclasses import dataclass
import parse

program = parse.get_program()

def iprint(*x):
    if re.match("^.L.:$", x[0]):
        print(*x)
    else:
        print("   ", *x)

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


stck = [0]


def stackreset():
    stck[0] = 0


def stackpush(yo):
    stck[0] -= 8
    iprint("subq $8, %rsp")
    loc = str(stck[0]) + "(%rbp)"
    iprint("movq " + yo + ", " + loc)
    return loc


labels = [6]


def label():
    labels[0] += 1
    return ".L" + str(labels[0])


@dataclass
class Function:
    name: str
    nargs: int
    asm: [str]

    def print(self):
        iprint(".globl", self.name)
        print(self.name + ":")
        iprint("pushq   %rbp")
        iprint("movq    %rsp, %rbp")
        stackreset()
        if self.nargs >= 1:
            stackpush("%rdi")
        if self.nargs >= 2:
            stackpush("%rsi")
        if self.nargs >= 3:
            stackpush("%rdx")
        if self.nargs >= 4:
            stackpush("%rcx")
        if self.nargs >= 5:
            stackpush("%r8")
        if self.nargs >= 6:
            stackpush("%r9")

        for step in self.asm:
            if type(step) == str:
                iprint(step)
            else:
                call(*step)

        iprint("movq    %rbp, %rsp")
        iprint("popq    %rbp")
        iprint("ret")

    def call(self, *args):
        assert len(args) == self.nargs + 1
        args = list(args)

        for i in range(1, len(args)):
            if type(args[i]) != str:
                args[i] = call(*args[i])
        if len(args) >= 7:
            iprint("movq    " + args[6] + ", %r9")
        if len(args) >= 6:
            iprint("movq    " + args[5] + ", %r8")
        if len(args) >= 5:
            iprint("movq    " + args[4] + ", %rcx")
        if len(args) >= 4:
            iprint("movq    " + args[3] + ", %rdx")
        if len(args) >= 3:
            iprint("movq    " + args[2] + ", %rsi")
        if len(args) >= 2:
            iprint("movq    " + args[1] + ", %rdi")
        iprint("call    " + self.name)
        return stackpush("%rax")


class Instr:
    def __init__(self, name):
        self.name = name
        self.nargs = 2

    def print(self):
        pass

    def call(self, name, a, b):
        if type(a) != str:
            a = call(*a)
        if type(b) != str:
            b = call(*b)
        iprint("movq " + a + ", %rax")
        iprint(self.name + "q " + b + ", %rax")
        return stackpush("%rax")


class If:
    def __init__(self):
        self.name = "if"
        self.nargs = 3

    def print(self):
        pass

    def call(self, name, cond, tru, fls):
        ret = stackpush("$0")
        restore = stck[0]
        if type(cond) != str:
            cond = call(*cond)
        iprint("cmpq $0,", cond)
        l1 = label()
        iprint("je", l1)
        if type(tru) != str:
            tru = call(*tru)
        iprint("movq ", tru + ", %rax")
        iprint("movq %rax,", ret)
        l2 = label()
        iprint("jmp", l2)
        iprint(l1 + ":")
        stck[0] = restore
        if type(fls) != str:
            fls = call(*fls)
        iprint("movq ", fls + ", %rax")
        iprint("movq %rax,", ret)
        iprint(l2 + ":")
        iprint("movq ", "%rbp, %rsp")
        iprint("subq    $" + str(-restore) + ", %rsp")
        return ret


def call(fname, *args):
    for function in functions:
        if function.name == fname:
            return function.call(fname, *args)
    if fname[0] == '$' and fname[1:].isdecimal() or fname in arg_stack_offsets:
        iprint("movq   " + fname + ", %rax")
        return stackpush("%rax")


    raise Exception(str(fname) + " not defined")


arg_stack_offsets = [f"-{8 * (i + 1)}(%rbp)" for i in range(6)]

# builtins
functions = [
    If(),
    Function(
        "print_",
        1,
        [
            "subq	$16, %rsp",
            "andq    $0xFFFFFFFFFFFFFFF0, %rsp",
            "movq	%rdi, -8(%rbp)",
            "movq	-8(%rbp), %rax",
            "movq	%rax, %rsi",
            "leaq	.LC0(%rip), %rax",
            "movq	%rax, %rdi",
            "movl	$0, %eax",
            "call	printf@PLT",
            "movq $0, %rax",
        ],
    ),
    Function(
        "cons_",
        2,
        [
            "subq    $32, %rsp",
            "andq    $0xFFFFFFFFFFFFFFF0, %rsp",
            "movq    %rdi, -24(%rbp)",
            "movq    %rsi, -32(%rbp)",
            "movl    $16, %edi",
            "call    malloc@PLT",
            "movq    %rax, -8(%rbp)",
            "movq    -24(%rbp), %rdx",
            "movq    -8(%rbp), %rax",
            "movq    %rdx, (%rax)",
            "movq    -8(%rbp), %rax",
            "leaq    8(%rax), %rdx",
            "movq    -32(%rbp), %rax",
            "movq    %rax, (%rdx)",
            "movq    -8(%rbp), %rax",
        ],
    ),
    Function("car_", 1, ["movq    -8(%rbp), %rax", "movq    (%rax), %rax"]),
    Function("cdr_", 1, ["movq    -8(%rbp), %rax", "movq    8(%rax), %rax"]),
]


print("""
    .text
    """)

for sexpr in program:
    if sexpr[:2] == ("backend", "asm"):
        if sexpr[2] == "Instr":
            functions.append(Instr(sexpr[3]))
        if sexpr[2] == "Linked":
            print(sexpr, file=sys.stderr)
            functions.append(Function(sexpr[3], int(sexpr[4]), ["call " + sexpr[3] + "_@PLT"]))


            

    if sexpr[0] == "defun":
        name, args, body = sexpr[1:]

        if type(body) == str:
            body = [body]

        def remap(expr):
            ret = []
            for e in expr:
                if e in args:
                    ret.append(arg_stack_offsets[args.index(e)])
                else:
                    if type(e) == str:
                        if re.match("[0-9]+", e):
                            ret.append("$" + e)
                        else:
                            ret.append(e)
                    elif type(e) == int:
                        ret.append("$" + str(e))
                    else:
                        ret.append(remap(e))
            return ret

        body = remap(body)
        functions.append(Function(name, len(args), [body]))

for f in functions:
    f.print()

print("""
	.section	.rodata
.LC0:
	.string	"%c"
    """)
