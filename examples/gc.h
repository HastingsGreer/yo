#ifndef LISP_H
#define LISP_H
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#ifndef __EMSCRIPTEN__
#include <execinfo.h>
void callstack();
#define callstack_assert(x)                                                    \
  if (!(x)) {                                                                  \
    callstack();                                                               \
    assert(x);                                                                 \
  }
#endif
#ifdef __EMSCRIPTEN__
#define callstack_assert(x) assert(x)
#endif

//#undef callstack_assert
//#define callstack_assert(x)

//Fat struct memory model
typedef enum __attribute__((packed))
Kind {
  NOTHING, LIST, STRING, NUMBER, PARENTDICT,
  LISPFUNCTION, STDLIBFUNCTION, FREE, NUM_KINDS,
} Kind;

typedef int Reference;

#define idx(Reference) (Reference & 0xFFFFFF)

#define generation(Reference) (Reference >> 24)

#define makeref(idx, generation) (idx + (((long)generation) << 24))

typedef struct FunctionBits {
  Reference body;
  Reference inner_args;
  Reference state;
} FunctionBits;


typedef struct Thing {
  Kind kind;
  char generation;
  char in_use;
  Reference nextChild;
  union {
  FunctionBits fbits;
  Reference child;
  char string[32];
  long number;
  Reference (*stdlib_func)(Reference, Reference);
  } payload;
} Thing;
#define n_things 500000

Thing *get(Reference ref);
int valid(Reference ref); 
Reference claim(Reference ref); 
Reference setup_freelist(); 
Reference thing_alloc(); 
void free_add_child(Reference parent, Reference child); 
void add_child(Reference parent, Reference child); 
void append_child(Reference parent, Reference child); 
void thing_free(Reference thing); 

//Interpreter
Reference list(); 
Reference pair(Reference a, Reference b); 
Reference wrap_number(long a); 
Reference parse_number(char **nextchar); 
int is_string(char c); 
Reference parse_string(char **nextchar); 
Reference wrap_string(char *a); 
int streq(Reference a, Reference b); 
Reference make_parent_dict(Reference parent); 
Reference pd_get(Reference dict, Reference string); 
void pd_set(Reference dict, Reference string, Reference value); 
Reference lisp_function_call(Reference function, Reference newargs,
                             Reference variables);
Reference execute(Reference variables, Reference s_expr); 
Reference eval(Reference variables, Reference term); 
Reference eval_stdlib(Reference arguments, Reference state); 
Reference lisp_function_call(Reference function, Reference newargs,
                             Reference variables); 

//Stdlib
#define arg_0(name)                                                            \
  Reference name = eval(state, get(get(args)->payload.child)->nextChild);
#define arg_1(name)                                                            \
  Reference name =                                                             \
      eval(state, get(get(get(args)->payload.child)->nextChild)->nextChild);
#define arg_2(name)                                                            \
  Reference name =                                                             \
      eval(state, get(get(get(get(args)->payload.child)->nextChild)->nextChild)->nextChild);
void print_thing(Reference r); 

Reference prints(Reference args, Reference state); 
Reference printv(Reference args, Reference state); 
Reference add(Reference args, Reference state); 
Reference mul(Reference args, Reference state); 
Reference gt(Reference args, Reference state); 
Reference malloc_(Reference args, Reference state); 
Reference free_(Reference args, Reference state); 
Reference peek8(Reference args, Reference state); 
Reference poke8(Reference args, Reference state); 
Reference peek4(Reference args, Reference state); 
Reference poke4(Reference args, Reference state); 
Reference peek(Reference args, Reference state); 
Reference poke(Reference args, Reference state); 
Reference addr(Reference args, Reference state); 
Reference kind(Reference args, Reference state); 
Reference head(Reference args, Reference state); 
Reference tail(Reference args, Reference state); 
Reference locals(Reference args, Reference state); 
Reference cons(Reference args, Reference state); 
Reference eq(Reference args, Reference state); 
Reference if_(Reference args, Reference state); 
Reference setv(Reference args, Reference state); 
Reference defun(Reference args, Reference state); 
Reference progn(Reference args, Reference state); 
Reference input_(Reference args, Reference state); 
Reference quote(Reference args, Reference state); 
Reference trampoline(Reference args, Reference state); 

//IO
Reference readfile(Reference args, Reference state); 
Reference read_file_raw(Reference args, Reference state); 
Reference parseList(char **nextchar); 
char *read_file(const char *path); 

//Garbage Collector
Reference _get_slot(int i); 
void mark_used(Reference r); 
Reference garbage_collect(Reference args, Reference state); 

//Collect stdlib
Reference wrap_stdlib(Reference (*libfunc)(Reference, Reference)); 
Reference make_stdlib(); 

int setupgc();
long car__(long list);
long cdr__(long list);
long cons__(long car, long cdr);

#endif
