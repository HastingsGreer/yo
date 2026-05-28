
    .text
    
    .globl print
print:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq	$16, %rsp
    andq    $0xFFFFFFFFFFFFFFF0, %rsp
    movq	%rdi, -8(%rbp)
    movq	-8(%rbp), %rax
    movq	%rax, %rsi
    leaq	.LC0(%rip), %rax
    movq	%rax, %rdi
    movl	$0, %eax
    call	printf@PLT
    movq $0, %rax
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl cons
cons:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq    $32, %rsp
    andq    $0xFFFFFFFFFFFFFFF0, %rsp
    movq    %rdi, -24(%rbp)
    movq    %rsi, -32(%rbp)
    movl    $16, %edi
    call    malloc@PLT
    movq    %rax, -8(%rbp)
    movq    -24(%rbp), %rdx
    movq    -8(%rbp), %rax
    movq    %rdx, (%rax)
    movq    -8(%rbp), %rax
    leaq    8(%rax), %rdx
    movq    -32(%rbp), %rax
    movq    %rax, (%rdx)
    movq    -8(%rbp), %rax
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl car
car:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rax
    movq    (%rax), %rax
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl cdr
cdr:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rax
    movq    8(%rax), %rax
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl main
main:
    pushq   %rbp
    movq    %rsp, %rbp
    movq    $10, %rdi
    call    x$range$_I64$__
    subq $8, %rsp
    movq %rax, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    x$circ$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -16(%rbp), %rdi
    call    x$print$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$add$_I64$_I64$__
x$add$_I64$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq $0, %rax
    subq -16(%rbp), %rax
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq -8(%rbp), %rax
    subq -24(%rbp), %rax
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$car$_x$List$_I64$__$__
x$car$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    car
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$car$_x$List$_x$List$_I64$__$__$__
x$car$_x$List$_x$List$_I64$__$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    car
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$cdr$_x$List$_I64$__$__
x$cdr$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    cdr
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$cdr$_x$List$_x$List$_I64$__$__$__
x$cdr$_x$List$_x$List$_I64$__$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    cdr
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$circ$_x$List$_I64$__$__
x$circ$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    x$sing$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -8(%rbp), %rsi
    movq    -16(%rbp), %rdi
    call    x$x$broadcast$_sumsquare$__$_x$List$_x$List$_I64$__$__$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$cons$_I64$_x$List$_I64$__$__
x$cons$_I64$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    cons
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$cons$_x$List$_I64$__$_x$List$_x$List$_I64$__$__$__
x$cons$_x$List$_I64$__$_x$List$_x$List$_I64$__$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    cons
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$divide$_I64$_I64$__
x$divide$_I64$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    movq -8(%rbp), %rax
    subq -16(%rbp), %rax
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rdi
    call    x$sign$_I64$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    $100, %rsi
    movq    -40(%rbp), %rdi
    call    x$eq$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    cmpq $0, -48(%rbp)
    je .L7
    movq -8(%rbp), %rax
    subq -16(%rbp), %rax
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq    -16(%rbp), %rsi
    movq    -56(%rbp), %rdi
    call    x$divide$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -64(%rbp)
    movq    -64(%rbp), %rsi
    movq    $1, %rdi
    call    x$add$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -72(%rbp)
    movq  -72(%rbp), %rax
    movq %rax, -24(%rbp)
    jmp .L8
.L7:
    movq  $0, %rax
    movq %rax, -24(%rbp)
.L8:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$do$_I64$_x$List$_I64$__$_I64$_I64$__
x$do$_I64$_x$List$_I64$__$_I64$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq %rdx, -24(%rbp)
    subq $8, %rsp
    movq %rcx, -32(%rbp)
    movq   -32(%rbp), %rax
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$eq$_I64$_I64$__
x$eq$_I64$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    movq -8(%rbp), %rax
    subq -16(%rbp), %rax
    subq $8, %rsp
    movq %rax, -32(%rbp)
    cmpq $0, -32(%rbp)
    je .L9
    movq  $0, %rax
    movq %rax, -24(%rbp)
    jmp .L10
.L9:
    movq  $1, %rax
    movq %rax, -24(%rbp)
    .L10:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$mod$_I64$_I64$__
x$mod$_I64$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    movq -8(%rbp), %rax
    subq -16(%rbp), %rax
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rdi
    call    x$sign$_I64$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    $100, %rsi
    movq    -40(%rbp), %rdi
    call    x$eq$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    cmpq $0, -48(%rbp)
    je .L11
    movq -8(%rbp), %rax
    subq -16(%rbp), %rax
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq    -16(%rbp), %rsi
    movq    -56(%rbp), %rdi
    call    x$mod$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -64(%rbp)
    movq  -64(%rbp), %rax
    movq %rax, -24(%rbp)
    jmp .L12
    .L11:
    movq  -8(%rbp), %rax
    movq %rax, -24(%rbp)
    .L12:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$mul$_I64$_I64$__
x$mul$_I64$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    movq    $0, %rsi
    movq    -8(%rbp), %rdi
    call    x$neq$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    cmpq $0, -32(%rbp)
    je .L13
    movq -8(%rbp), %rax
    subq $1, %rax
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -16(%rbp), %rsi
    movq    -40(%rbp), %rdi
    call    x$mul$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    -48(%rbp), %rsi
    movq    -16(%rbp), %rdi
    call    x$add$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq  -56(%rbp), %rax
    movq %rax, -24(%rbp)
    jmp .L14
    .L13:
    call    x$x$zero$_I64$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq  -32(%rbp), %rax
    movq %rax, -24(%rbp)
    .L14:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$neq$_I64$_I64$__
x$neq$_I64$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$eq$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    cmpq $0, -32(%rbp)
    je .L15
    movq  $0, %rax
    movq %rax, -24(%rbp)
    jmp .L16
    .L15:
    movq  $1, %rax
    movq %rax, -24(%rbp)
    .L16:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$nil$_I64$__
x$nil$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    call    x$x$nilptr$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$nil$_x$List$_I64$__$__
x$nil$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    call    x$x$nilptr$_x$List$_x$List$_I64$__$__$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$print$_I64$__
x$print$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    x$printdigits$_I64$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    $32, %rdi
    call    print
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rsi
    movq    -16(%rbp), %rdi
    call    x$add$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$print$_x$List$_I64$__$__
x$print$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    $40, %rdi
    call    print
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -8(%rbp), %rdi
    call    x$x$map$_print$__$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    $41, %rdi
    call    print
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    $32, %rdi
    call    print
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -40(%rbp), %rcx
    movq    -32(%rbp), %rdx
    movq    -24(%rbp), %rsi
    movq    -16(%rbp), %rdi
    call    x$do$_I64$_x$List$_I64$__$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$print$_x$List$_x$List$_I64$__$__$__
x$print$_x$List$_x$List$_I64$__$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    $40, %rdi
    call    print
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -8(%rbp), %rdi
    call    x$x$map$_print$__$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    $41, %rdi
    call    print
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    $32, %rdi
    call    print
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -40(%rbp), %rcx
    movq    -32(%rbp), %rdx
    movq    -24(%rbp), %rsi
    movq    -16(%rbp), %rdi
    call    x$do$_I64$_x$List$_I64$__$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$printdigits$_I64$__
x$printdigits$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq $0, -16(%rbp)
    movq    $10, %rsi
    movq    -8(%rbp), %rdi
    call    x$divide$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    cmpq $0, -24(%rbp)
    je .L17
    movq    $10, %rsi
    movq    -8(%rbp), %rdi
    call    x$divide$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rdi
    call    x$printdigits$_I64$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq  -40(%rbp), %rax
    movq %rax, -16(%rbp)
    jmp .L18
    .L17:
    movq  $0, %rax
    movq %rax, -16(%rbp)
    .L18:
    movq  %rbp, %rsp
    subq    $16, %rsp
    movq    $10, %rsi
    movq    -8(%rbp), %rdi
    call    x$mod$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rsi
    movq    $48, %rdi
    call    x$add$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rdi
    call    print
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -40(%rbp), %rsi
    movq    -16(%rbp), %rdi
    call    x$add$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$range$_I64$__
x$range$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq $0, -16(%rbp)
    cmpq $0, -8(%rbp)
    je .L19
    movq -8(%rbp), %rax
    subq $1, %rax
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rdi
    call    x$range$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$cons$_I64$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq  -40(%rbp), %rax
    movq %rax, -16(%rbp)
    jmp .L20
    .L19:
    movq    $0, %rdi
    call    x$nil$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq  -24(%rbp), %rax
    movq %rax, -16(%rbp)
    .L20:
    movq  %rbp, %rsp
    subq    $16, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sign$_I64$__
x$sign$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq $0, %rax
    subq -8(%rbp), %rax
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$sign_impl$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sign_impl$_I64$_I64$__
x$sign_impl$_I64$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    movq    $0, %rsi
    movq    -8(%rbp), %rdi
    call    x$eq$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    cmpq $0, -32(%rbp)
    je .L21
    movq  $100, %rax
    movq %rax, -24(%rbp)
    jmp .L22
    .L21:
    subq $8, %rsp
    movq $0, -32(%rbp)
    movq    $0, %rsi
    movq    -16(%rbp), %rdi
    call    x$eq$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    cmpq $0, -40(%rbp)
    je .L23
    movq  $101, %rax
    movq %rax, -32(%rbp)
    jmp .L24
    .L23:
    movq -8(%rbp), %rax
    subq $1, %rax
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq -16(%rbp), %rax
    subq $1, %rax
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    -48(%rbp), %rsi
    movq    -40(%rbp), %rdi
    call    x$sign_impl$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq  -56(%rbp), %rax
    movq %rax, -32(%rbp)
    .L24:
    movq  %rbp, %rsp
    subq    $32, %rsp
    movq  -32(%rbp), %rax
    movq %rax, -24(%rbp)
    .L22:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sing$_x$List$_I64$__$__
x$sing$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    call    x$x$nil$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$cons$_x$List$_I64$__$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sumsquare$_I64$_I64$__
x$sumsquare$_I64$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -8(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$mul$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -16(%rbp), %rsi
    movq    -16(%rbp), %rdi
    call    x$mul$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rsi
    movq    -24(%rbp), %rdi
    call    x$add$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$broadcast$_sumsquare$__$_x$List$_I64$__$_I64$__
x$x$broadcast$_sumsquare$__$_x$List$_I64$__$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    cmpq $0, -8(%rbp)
    je .L25
    movq    -8(%rbp), %rdi
    call    x$car$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -16(%rbp), %rsi
    movq    -32(%rbp), %rdi
    call    x$sumsquare$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -8(%rbp), %rdi
    call    x$cdr$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    -16(%rbp), %rsi
    movq    -48(%rbp), %rdi
    call    x$x$broadcast$_sumsquare$__$_x$List$_I64$__$_I64$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq    -56(%rbp), %rsi
    movq    -40(%rbp), %rdi
    call    x$cons$_I64$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -64(%rbp)
    movq  -64(%rbp), %rax
    movq %rax, -24(%rbp)
    jmp .L26
    .L25:
    movq    $0, %rdi
    call    x$nil$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq  -32(%rbp), %rax
    movq %rax, -24(%rbp)
    .L26:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$broadcast$_sumsquare$__$_x$List$_x$List$_I64$__$__$_x$List$_I64$__$__
x$x$broadcast$_sumsquare$__$_x$List$_x$List$_I64$__$__$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -8(%rbp), %rdi
    call    x$car$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -16(%rbp), %rdi
    call    x$car$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rsi
    movq    -24(%rbp), %rdi
    call    x$x$broadcast$_sumsquare$__$_x$List$_I64$__$_I64$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    subq $8, %rsp
    movq $0, -48(%rbp)
    movq    -8(%rbp), %rdi
    call    x$cdr$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    cmpq $0, -56(%rbp)
    je .L27
    subq $8, %rsp
    movq $0, -64(%rbp)
    movq    -16(%rbp), %rdi
    call    x$cdr$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -72(%rbp)
    cmpq $0, -72(%rbp)
    je .L28
    movq    -8(%rbp), %rdi
    call    x$cdr$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -80(%rbp)
    movq    -16(%rbp), %rdi
    call    x$cdr$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -88(%rbp)
    movq    -88(%rbp), %rsi
    movq    -80(%rbp), %rdi
    call    x$x$broadcast$_sumsquare$__$_x$List$_x$List$_I64$__$__$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -96(%rbp)
    movq  -96(%rbp), %rax
    movq %rax, -64(%rbp)
    jmp .L29
    .L28:
    movq    -8(%rbp), %rdi
    call    x$cdr$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -72(%rbp)
    movq    -16(%rbp), %rsi
    movq    -72(%rbp), %rdi
    call    x$x$broadcast$_sumsquare$__$_x$List$_x$List$_I64$__$__$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -80(%rbp)
    movq  -80(%rbp), %rax
    movq %rax, -64(%rbp)
    .L29:
    movq  %rbp, %rsp
    subq    $64, %rsp
    movq  -64(%rbp), %rax
    movq %rax, -48(%rbp)
    jmp .L30
    .L27:
    subq $8, %rsp
    movq $0, -56(%rbp)
    movq    -16(%rbp), %rdi
    call    x$cdr$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -64(%rbp)
    cmpq $0, -64(%rbp)
    je .L31
    movq    -16(%rbp), %rdi
    call    x$cdr$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -72(%rbp)
    movq    -72(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$x$broadcast$_sumsquare$__$_x$List$_x$List$_I64$__$__$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -80(%rbp)
    movq  -80(%rbp), %rax
    movq %rax, -56(%rbp)
    jmp .L32
    .L31:
    movq    $0, %rdi
    call    x$nil$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -64(%rbp)
    movq  -64(%rbp), %rax
    movq %rax, -56(%rbp)
    .L32:
    movq  %rbp, %rsp
    subq    $56, %rsp
    movq  -56(%rbp), %rax
    movq %rax, -48(%rbp)
    .L30:
    movq  %rbp, %rsp
    subq    $48, %rsp
    movq    -48(%rbp), %rsi
    movq    -40(%rbp), %rdi
    call    x$cons$_x$List$_I64$__$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -72(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$map$_print$__$_x$List$_I64$__$__
x$x$map$_print$__$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq $0, -16(%rbp)
    cmpq $0, -8(%rbp)
    je .L33
    movq    -8(%rbp), %rdi
    call    x$car$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rdi
    call    x$print$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -8(%rbp), %rdi
    call    x$cdr$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -40(%rbp), %rdi
    call    x$x$map$_print$__$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    -48(%rbp), %rsi
    movq    -32(%rbp), %rdi
    call    x$cons$_I64$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq  -56(%rbp), %rax
    movq %rax, -16(%rbp)
    jmp .L34
    .L33:
    movq    $0, %rdi
    call    x$nil$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq  -24(%rbp), %rax
    movq %rax, -16(%rbp)
    .L34:
    movq  %rbp, %rsp
    subq    $16, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$map$_print$__$_x$List$_x$List$_I64$__$__$__
x$x$map$_print$__$_x$List$_x$List$_I64$__$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq $0, -16(%rbp)
    cmpq $0, -8(%rbp)
    je .L35
    movq    -8(%rbp), %rdi
    call    x$car$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rdi
    call    x$print$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -8(%rbp), %rdi
    call    x$cdr$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -40(%rbp), %rdi
    call    x$x$map$_print$__$_x$List$_x$List$_I64$__$__$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    -48(%rbp), %rsi
    movq    -32(%rbp), %rdi
    call    x$cons$_I64$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq  -56(%rbp), %rax
    movq %rax, -16(%rbp)
    jmp .L36
    .L35:
    movq    $0, %rdi
    call    x$nil$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq  -24(%rbp), %rax
    movq %rax, -16(%rbp)
    .L36:
    movq  %rbp, %rsp
    subq    $16, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$nil$_x$List$_I64$__$__$__
x$x$nil$_x$List$_I64$__$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    call    x$x$nilptr$_x$List$_x$List$_I64$__$__$__$__
    subq $8, %rsp
    movq %rax, -8(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$nilptr$_I64$__$__
x$x$nilptr$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    movq   $0, %rax
    subq $8, %rsp
    movq %rax, -8(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$nilptr$_x$List$_I64$__$__$__
x$x$nilptr$_x$List$_I64$__$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    movq   $0, %rax
    subq $8, %rsp
    movq %rax, -8(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$nilptr$_x$List$_x$List$_I64$__$__$__$__
x$x$nilptr$_x$List$_x$List$_I64$__$__$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    movq   $0, %rax
    subq $8, %rsp
    movq %rax, -8(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$zero$_I64$__$__
x$x$zero$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    movq   $0, %rax
    subq $8, %rsp
    movq %rax, -8(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret

	.section	.rodata
.LC0:
	.string	"%c"
    
