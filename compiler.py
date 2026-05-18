import re
from dataclasses import dataclass

source = """
(defun powtwo (a) (if a (add (powtwo (sub a 1)) (powtwo (sub a 1))) 1))

(defun main () (powtwo 5))
"""

source = open("fib.lisp", "r").read()
program_file = re.sub(r"([A-Za-z+_=\-\?]+[0-9]*)", r"'\1',", source)
program_file = re.sub(r"([0-9]+)", r"\1,", program_file)
program_file = "(" + re.sub("\\)", "),", program_file) + ")"

program = eval(program_file)

def iprint(*x):
    if re.match("^.L.:$", x[0]):
        print(*x)
    else:
        print("   ", *x)


stck = [0]


def stackreset():
    stck[0] = 0


def stackpush(yo):
    iprint("pushq " + yo)
    stck[0] -= 8
    return str(stck[0]) + "(%rbp)"


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
        if self.nargs == 2:
            stackpush("%rsi")

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

        if len(args) == 3:
            iprint("movq    " + args[2] + ", %rsi")
        if len(args) >= 2:
            iprint("movq    " + args[1] + ", %rdi")
        iprint("call    " + self.name)
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

arg0 = "-8(%rbp)"
arg1 = "-16(%rbp)"

#builtins
functions = [
    If(),
    Function (
        "print",
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
    ]),
    Function(
        "cons",
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
        ]
        ),
    Function(
        "car",
        1,
        [
        "movq    -8(%rbp), %rax",
        "movq    (%rax), %rax"
        ]
        ),
    Function(
        "cdr",
        1,
        [
        "movq    -8(%rbp), %rax",
        "movq    8(%rax), %rax"
        ]
        ),

    Function(
        "add",
        2,
        [
            "movq    -8(%rbp), %rax",
            "addq    -16(%rbp), %rax",
        ],
    ),
    Function(
        "sub",
        2,
        [
            "movq    -8(%rbp), %rax",
            "subq    -16(%rbp), %rax",
        ],
    ),
]


print(
    """
    .text
    """
)

for sexpr in program:
    if sexpr[0] == "defun":
        name, args, body = sexpr[1:]
        def remap(expr):
            ret = []
            for e in expr:
                if e in args:
                    ret.append([arg0, arg1][args.index(e)])
                else:
                    if type(e) == str:
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
	.string	"%li "
    """)


