
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
    movq    $13, %rdi
    call    x$Consint$_I64$__
    subq $8, %rsp
    movq %rax, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    x$x$Signedof$_Consint$__$_Consint$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -16(%rbp), %rdi
    call    x$isprime$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rdi
    call    print
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$Consint$_I64$__
x$Consint$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    x$range$_I64$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -16(%rbp), %rdi
    call    x$x$map$_zero_$__$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$add$_Consint$_Consint$__
x$add$_Consint$_Consint$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    cmpq $0, -16(%rbp)
    je .L7
    movq    -8(%rbp), %rdi
    call    x$inc$_Consint$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -16(%rbp), %rdi
    call    x$dec$_Consint$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -40(%rbp), %rsi
    movq    -32(%rbp), %rdi
    call    x$add$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq  -48(%rbp), %rax
    movq %rax, -24(%rbp)
    jmp .L8
.L7:
    movq  -8(%rbp), %rax
    movq %rax, -24(%rbp)
.L8:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$car$_x$List$_Consint$__$__
x$car$_x$List$_Consint$__$__:
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
    .globl x$cdr$_x$List$_Consint$__$__
x$cdr$_x$List$_Consint$__$__:
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
    .globl x$cons$_Consint$_x$List$_Consint$__$__
x$cons$_Consint$_x$List$_Consint$__$__:
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
    .globl x$dec$_Consint$__
x$dec$_Consint$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    x$cdr$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$eq$_Consint$_I64$__
x$eq$_Consint$_I64$__:
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
    call    x$sub$_Consint$_I64$__
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
    je .L11
    movq  $0, %rax
    movq %rax, -24(%rbp)
    jmp .L12
    .L11:
    movq  $1, %rax
    movq %rax, -24(%rbp)
    .L12:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$eq$_x$Signedof$_Consint$__$_I64$__
x$eq$_x$Signedof$_Consint$__$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -16(%rbp), %rdi
    call    x$x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$eq$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$eq$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
x$eq$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    movq    -8(%rbp), %rdi
    call    x$first$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -16(%rbp), %rdi
    call    x$first$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -40(%rbp), %rsi
    movq    -32(%rbp), %rdi
    call    x$sub$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    cmpq $0, -48(%rbp)
    je .L13
    movq  $0, %rax
    movq %rax, -24(%rbp)
    jmp .L14
    .L13:
    subq $8, %rsp
    movq $0, -32(%rbp)
    movq    -8(%rbp), %rdi
    call    x$second$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -16(%rbp), %rdi
    call    x$second$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    -48(%rbp), %rsi
    movq    -40(%rbp), %rdi
    call    x$sub$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    cmpq $0, -56(%rbp)
    je .L15
    movq  $0, %rax
    movq %rax, -32(%rbp)
    jmp .L16
    .L15:
    movq  $1, %rax
    movq %rax, -32(%rbp)
    .L16:
    movq  %rbp, %rsp
    subq    $32, %rsp
    movq  -32(%rbp), %rax
    movq %rax, -24(%rbp)
    .L14:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$first$_x$Signedof$_Consint$__$__
x$first$_x$Signedof$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    x$car$_x$List$_Consint$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$inc$_Consint$__
x$inc$_Consint$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rsi
    movq    $0, %rdi
    call    x$cons$_I64$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$isprime$_x$Signedof$_Consint$__$__
x$isprime$_x$Signedof$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq $0, -16(%rbp)
    movq    $1, %rsi
    movq    -8(%rbp), %rdi
    call    x$neq$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    cmpq $0, -24(%rbp)
    je .L17
    movq    $1, %rsi
    movq    -8(%rbp), %rdi
    call    x$sub$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$prime_impl$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
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
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$mod$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
x$mod$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__:
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
    call    x$sub$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rdi
    call    x$sign$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    $100, %rsi
    movq    -40(%rbp), %rdi
    call    x$eq$_I64$_I64$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    cmpq $0, -48(%rbp)
    je .L19
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$sub$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq    -16(%rbp), %rsi
    movq    -56(%rbp), %rdi
    call    x$mod$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -64(%rbp)
    movq  -64(%rbp), %rax
    movq %rax, -24(%rbp)
    jmp .L20
    .L19:
    movq  -8(%rbp), %rax
    movq %rax, -24(%rbp)
    .L20:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$neq$_Consint$_I64$__
x$neq$_Consint$_I64$__:
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
    call    x$eq$_Consint$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    cmpq $0, -32(%rbp)
    je .L21
    movq  $0, %rax
    movq %rax, -24(%rbp)
    jmp .L22
    .L21:
    movq  $1, %rax
    movq %rax, -24(%rbp)
    .L22:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$neq$_x$Signedof$_Consint$__$_I64$__
x$neq$_x$Signedof$_Consint$__$_I64$__:
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
    call    x$eq$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    cmpq $0, -32(%rbp)
    je .L23
    movq  $0, %rax
    movq %rax, -24(%rbp)
    jmp .L24
    .L23:
    movq  $1, %rax
    movq %rax, -24(%rbp)
    .L24:
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
    .globl x$normform$_x$Signedof$_Consint$__$__
x$normform$_x$Signedof$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq $0, -16(%rbp)
    movq    -8(%rbp), %rdi
    call    x$first$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    $0, %rsi
    movq    -24(%rbp), %rdi
    call    x$neq$_Consint$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    cmpq $0, -32(%rbp)
    je .L25
    subq $8, %rsp
    movq $0, -40(%rbp)
    movq    -8(%rbp), %rdi
    call    x$second$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    $0, %rsi
    movq    -48(%rbp), %rdi
    call    x$neq$_Consint$_I64$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    cmpq $0, -56(%rbp)
    je .L26
    movq    -8(%rbp), %rdi
    call    x$first$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -64(%rbp)
    movq    $1, %rsi
    movq    -64(%rbp), %rdi
    call    x$sub$_Consint$_I64$__
    subq $8, %rsp
    movq %rax, -72(%rbp)
    movq    -8(%rbp), %rdi
    call    x$second$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -80(%rbp)
    movq    $1, %rsi
    movq    -80(%rbp), %rdi
    call    x$sub$_Consint$_I64$__
    subq $8, %rsp
    movq %rax, -88(%rbp)
    movq    -88(%rbp), %rsi
    movq    -72(%rbp), %rdi
    call    x$x$Signedof$_Consint$__$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -96(%rbp)
    movq    -96(%rbp), %rdi
    call    x$normform$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -104(%rbp)
    movq  -104(%rbp), %rax
    movq %rax, -40(%rbp)
    jmp .L27
    .L26:
    movq  -8(%rbp), %rax
    movq %rax, -40(%rbp)
    .L27:
    movq  %rbp, %rsp
    subq    $40, %rsp
    movq  -40(%rbp), %rax
    movq %rax, -16(%rbp)
    jmp .L28
    .L25:
    movq  -8(%rbp), %rax
    movq %rax, -16(%rbp)
    .L28:
    movq  %rbp, %rsp
    subq    $16, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$pair$_Consint$_Consint$__
x$pair$_Consint$_Consint$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    call    x$x$nil$_Consint$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rsi
    movq    -16(%rbp), %rdi
    call    x$cons$_Consint$_x$List$_Consint$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$cons$_Consint$_x$List$_Consint$__$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$prime_impl$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
x$prime_impl$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    movq    $1, %rsi
    movq    -16(%rbp), %rdi
    call    x$neq$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    cmpq $0, -32(%rbp)
    je .L29
    subq $8, %rsp
    movq $0, -40(%rbp)
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$mod$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    $0, %rsi
    movq    -48(%rbp), %rdi
    call    x$neq$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    cmpq $0, -56(%rbp)
    je .L30
    movq    $1, %rsi
    movq    -16(%rbp), %rdi
    call    x$sub$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -64(%rbp)
    movq    -64(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$prime_impl$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -72(%rbp)
    movq  -72(%rbp), %rax
    movq %rax, -40(%rbp)
    jmp .L31
    .L30:
    movq  $0, %rax
    movq %rax, -40(%rbp)
    .L31:
    movq  %rbp, %rsp
    subq    $40, %rsp
    movq  -40(%rbp), %rax
    movq %rax, -24(%rbp)
    jmp .L32
    .L29:
    movq  $1, %rax
    movq %rax, -24(%rbp)
    .L32:
    movq  %rbp, %rsp
    subq    $24, %rsp
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
    je .L33
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
    .globl x$second$_x$Signedof$_Consint$__$__
x$second$_x$Signedof$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    x$cdr$_x$List$_Consint$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -16(%rbp), %rdi
    call    x$car$_x$List$_Consint$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sign$_x$Signedof$_Consint$__$__
x$sign$_x$Signedof$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rsi
    movq    $0, %rdi
    call    x$sub$_I64$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$sign_impl$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sign_impl$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
x$sign_impl$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__:
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
    call    x$eq$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    cmpq $0, -32(%rbp)
    je .L35
    movq  $100, %rax
    movq %rax, -24(%rbp)
    jmp .L36
    .L35:
    subq $8, %rsp
    movq $0, -32(%rbp)
    movq    $0, %rsi
    movq    -16(%rbp), %rdi
    call    x$eq$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    cmpq $0, -40(%rbp)
    je .L37
    movq  $101, %rax
    movq %rax, -32(%rbp)
    jmp .L38
    .L37:
    movq    $1, %rsi
    movq    -8(%rbp), %rdi
    call    x$sub$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    $1, %rsi
    movq    -16(%rbp), %rdi
    call    x$sub$_x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    -48(%rbp), %rsi
    movq    -40(%rbp), %rdi
    call    x$sign_impl$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq  -56(%rbp), %rax
    movq %rax, -32(%rbp)
    .L38:
    movq  %rbp, %rsp
    subq    $32, %rsp
    movq  -32(%rbp), %rax
    movq %rax, -24(%rbp)
    .L36:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sub$_Consint$_Consint$__
x$sub$_Consint$_Consint$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    subq $8, %rsp
    movq $0, -24(%rbp)
    cmpq $0, -16(%rbp)
    je .L39
    movq    -8(%rbp), %rdi
    call    x$dec$_Consint$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -16(%rbp), %rdi
    call    x$dec$_Consint$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -40(%rbp), %rsi
    movq    -32(%rbp), %rdi
    call    x$sub$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq  -48(%rbp), %rax
    movq %rax, -24(%rbp)
    jmp .L40
    .L39:
    movq  -8(%rbp), %rax
    movq %rax, -24(%rbp)
    .L40:
    movq  %rbp, %rsp
    subq    $24, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sub$_Consint$_I64$__
x$sub$_Consint$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -16(%rbp), %rdi
    call    x$Consint$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$sub$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sub$_I64$_x$Signedof$_Consint$__$__
x$sub$_I64$_x$Signedof$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -8(%rbp), %rdi
    call    x$x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -16(%rbp), %rsi
    movq    -24(%rbp), %rdi
    call    x$sub$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sub$_x$Signedof$_Consint$__$_I64$__
x$sub$_x$Signedof$_Consint$__$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -16(%rbp), %rdi
    call    x$x$Signedof$_Consint$__$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$sub$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$sub$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__
x$sub$_x$Signedof$_Consint$__$_x$Signedof$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -8(%rbp), %rdi
    call    x$first$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -16(%rbp), %rdi
    call    x$second$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -32(%rbp), %rsi
    movq    -24(%rbp), %rdi
    call    x$add$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -8(%rbp), %rdi
    call    x$second$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    -16(%rbp), %rdi
    call    x$first$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq    -56(%rbp), %rsi
    movq    -48(%rbp), %rdi
    call    x$add$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -64(%rbp)
    movq    -64(%rbp), %rsi
    movq    -40(%rbp), %rdi
    call    x$x$Signedof$_Consint$__$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -72(%rbp)
    movq    -72(%rbp), %rdi
    call    x$normform$_x$Signedof$_Consint$__$__
    subq $8, %rsp
    movq %rax, -80(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$Signedof$_Consint$__$_Consint$_Consint$__
x$x$Signedof$_Consint$__$_Consint$_Consint$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq %rsi, -16(%rbp)
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$pair$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$Signedof$_Consint$__$_Consint$__
x$x$Signedof$_Consint$__$_Consint$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    call    x$x$zero$_Consint$__$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    x$x$Signedof$_Consint$__$_Consint$_Consint$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$Signedof$_Consint$__$_I64$__
x$x$Signedof$_Consint$__$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq    -8(%rbp), %rdi
    call    x$Consint$_I64$__
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    -16(%rbp), %rdi
    call    x$x$Signedof$_Consint$__$_Consint$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$map$_zero_$__$_x$List$_I64$__$__
x$x$map$_zero_$__$_x$List$_I64$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    subq $8, %rsp
    movq $0, -16(%rbp)
    cmpq $0, -8(%rbp)
    je .L41
    movq    -8(%rbp), %rdi
    call    x$car$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq    -24(%rbp), %rdi
    call    x$zero_$_I64$__
    subq $8, %rsp
    movq %rax, -32(%rbp)
    movq    -8(%rbp), %rdi
    call    x$cdr$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -40(%rbp)
    movq    -40(%rbp), %rdi
    call    x$x$map$_zero_$__$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -48(%rbp)
    movq    -48(%rbp), %rsi
    movq    -32(%rbp), %rdi
    call    x$cons$_I64$_x$List$_I64$__$__
    subq $8, %rsp
    movq %rax, -56(%rbp)
    movq  -56(%rbp), %rax
    movq %rax, -16(%rbp)
    jmp .L42
    .L41:
    movq    $0, %rdi
    call    x$nil$_I64$__
    subq $8, %rsp
    movq %rax, -24(%rbp)
    movq  -24(%rbp), %rax
    movq %rax, -16(%rbp)
    .L42:
    movq  %rbp, %rsp
    subq    $16, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$x$nil$_Consint$__$__
x$x$nil$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    call    x$x$nilptr$_x$List$_Consint$__$__$__
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
    .globl x$x$nilptr$_x$List$_Consint$__$__$__
x$x$nilptr$_x$List$_Consint$__$__$__:
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
    .globl x$x$zero$_Consint$__$__
x$x$zero$_Consint$__$__:
    pushq   %rbp
    movq    %rsp, %rbp
    movq    $0, %rdi
    call    x$Consint$_I64$__
    subq $8, %rsp
    movq %rax, -8(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret
    .globl x$zero_$_I64$__
x$zero_$_I64$__:
    pushq   %rbp
    movq    %rsp, %rbp
    subq $8, %rsp
    movq %rdi, -8(%rbp)
    movq   $0, %rax
    subq $8, %rsp
    movq %rax, -16(%rbp)
    movq    %rbp, %rsp
    popq    %rbp
    ret

	.section	.rodata
.LC0:
	.string	"%li "
    
