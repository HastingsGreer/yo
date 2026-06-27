#include <assert.h>
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "gc.h"

#define stacktrace_l 60
void callstack() {
  void *array[stacktrace_l];
  size_t size;
  size = backtrace(array, stacktrace_l);
  fprintf(stderr, "Error:");
  backtrace_symbols_fd(array, size, STDERR_FILENO);
}


Thing things[n_things] = {0};
Reference freelist;

Thing *get(Reference ref) {
  Thing *result = &things[idx(ref)];
  callstack_assert(result->generation == generation(ref));
  return result;
}

int valid(Reference ref) {
  if (idx(ref) < 0 || idx(ref) >= n_things) {
    return 0;
  }
  Thing *result = &things[idx(ref)];
  return (result->generation == generation(ref));
}

Reference claim(Reference ref) {
  long gen = ++(get(ref)->generation);
  Reference result = makeref(idx(ref), gen);
  Thing *result_ptr = &things[idx(result)];
  *result_ptr = (Thing){0};
  result_ptr->generation = generation(result);
  return result;
}


Reference setup_freelist() {
  memset(&things, 0, sizeof(things));
  things[0].generation = -1;
  Reference freelist_holder_ref = claim(makeref(1l, 0l));
  get(freelist_holder_ref)->payload.child = claim(makeref(2l, 0l));
  for (int i = 2; i < n_things - 1; i++) {
    things[i].generation = 1;
    things[i].nextChild = makeref(i + 1, 1);
    things[i].kind = FREE;
  }
  things[n_things - 1].generation = 1;
  things[n_things - 1].kind = FREE;
  return freelist_holder_ref;
}
int n_used = 0;
Reference thing_alloc() {
  n_used++;
  Reference result = get(freelist)->payload.child;
  callstack_assert(idx(result));
  if (!valid(get(result)->nextChild)) {
    printf("ping\n");
    garbage_collect(0, 0);
    result = get(freelist)->payload.child;
  }
  get(freelist)->payload.child = get(result)->nextChild;
  return claim(result);
}

void free_add_child(Reference parent, Reference child) {
  get(child)->nextChild = get(parent)->payload.child;
  get(parent)->payload.child = child;
  get(child)->kind = FREE;
}

void add_child(Reference parent, Reference child) {
  assert(get(child)->kind != PARENTDICT);
  Reference new_Child = thing_alloc();
  int generation = get(new_Child)->generation;

  *get(new_Child) = *get(child);

  things[idx(new_Child)].generation = generation;

  get(new_Child)->nextChild = get(parent)->payload.child;
  get(parent)->payload.child = new_Child;
}

void append_child(Reference parent, Reference child) {
  assert(get(child)->kind != PARENTDICT);
  Reference lastChild = get(parent)->payload.child;
  if (!valid(lastChild)) {
    get(parent)->payload.child = child;
    return;
  }
  while (valid(get(lastChild)->nextChild)) {
    lastChild = get(lastChild)->nextChild;
  }
  get(lastChild)->nextChild = child;
}

void thing_free(Reference thing) {
	n_used--;
  callstack_assert(get(thing)->kind != FREE);
  thing = claim(thing);
  free_add_child(freelist, thing);
}

Reference list() {
  Reference parent = thing_alloc();
  get(parent)->kind = LIST;
  return parent;
}

Reference pair(Reference a, Reference b) {
  Reference parent = thing_alloc();
  get(parent)->kind = LIST;
  add_child(parent, b);
  add_child(parent, a);
  return parent;
}

Reference wrap_number(long a) {
  Reference ret = thing_alloc();
  get(ret)->kind = NUMBER;
  get(ret)->payload.number = a;
  return ret;
}

Reference parse_number(char **nextchar) {
  int result = 0;
  while (**nextchar >= '0' && **nextchar <= '9') {
    result *= 10;
    result = result + **nextchar - '0';
    ++*nextchar;
  }
  return wrap_number(result);
}

int is_string(char c) {
  if (c >= 'A' && c <= 'Z')
    return 1;
  if (c >= 'a' && c <= 'z')
    return 1;
  if (c == '+')
    return 1;
  if (c == '-')
    return 1;
  if (c == '=')
    return 1;
  if (c == '>')
    return 1;
  if (c == '<')
    return 1;
  if (c == '*')
    return 1;
  if (c == '/')
    return 1;
  if (c == '_')
    return 1;
  if (c == '@')
    return 1;
  if (c == '.')
    return 1;
  if (c == '?')
    return 1;
  if (c == '$') return 1;
  if (c == ',') return 1;
  if (c == '#') return 1;
  if (c == '[') return 1;
  if (c == ']') return 1;
  if (c == ':') return 1;
  if (c == ';') return 1;
  if (c == '"') return 1;
  if (c == '%') return 1;

  if (c == '\'')
    return 1;

  return 0;
}
Reference parse_string(char **nextchar) {
  Reference ret = thing_alloc();
  get(ret)->kind = STRING;
  char *i = get(ret)->payload.string;
  while (is_string(**nextchar) || (**nextchar >= '0' && **nextchar <= '9')) {
    *i = **nextchar;
    ++i;
    ++*nextchar;
  }
  return ret;
}

Reference wrap_string(char *a) {
  Reference ret = thing_alloc();
  get(ret)->kind = STRING;
  strcpy(get(ret)->payload.string, a);
  return ret;
}
int streq(Reference a, Reference b) {
  callstack_assert(get(a)->kind == STRING);
  callstack_assert(get(b)->kind == STRING);
  for (int i = 0; i < 16; i++) {
    if (get(a)->payload.string[i] != get(b)->payload.string[i]) {
      return 0;
    }
  }
  return 1;
}

Reference make_parent_dict(Reference parent) {
  Reference dict = list();
  Reference locals = list();
  if (valid(parent)) {
    get(dict)->payload.child = get(parent)->payload.child;
  } else {
  }
  add_child(dict, locals);
  return dict;
}

Reference pd_get(Reference dict, Reference string) {
  callstack_assert(get(dict)->kind == LIST);
  callstack_assert(get(string)->kind == STRING);
  Reference locals = get(dict)->payload.child;

  while (1) {
    Reference next_pair = get(locals)->payload.child;
    while (valid(next_pair)) {
      callstack_assert(get(next_pair)->kind == LIST);
      if (streq(get(next_pair)->payload.child, string)) {
        return get(get(next_pair)->payload.child)->nextChild;
      }
      next_pair = get(next_pair)->nextChild;
    }
    if (!valid(get(locals)->nextChild)) {
      printf("could not find ");
      print_thing(string);
      printf("\n");
      callstack_assert(0);
      exit(1);
    }
    locals = get(locals)->nextChild;
  }
}

void pd_set(Reference dict, Reference string, Reference value) {
  callstack_assert(get(dict)->kind == LIST);
  callstack_assert(get(string)->kind == STRING);
  Reference kv_pair = pair(string, value);
  Reference locals = get(dict)->payload.child;
  add_child(locals, kv_pair);
}

Reference execute(Reference variables, Reference s_expr) {
  callstack_assert(get(variables)->kind == LIST);
  callstack_assert(get(s_expr)->kind == LIST);

  Reference function_name = get(s_expr)->payload.child;

  Reference function = eval(variables, function_name);

  if (get(function)->kind == LISPFUNCTION) {
  //printf("%s\n", get(function_name)->payload.string);
    return lisp_function_call(function, s_expr, variables);
  } else {
    callstack_assert(get(function)->kind == STDLIBFUNCTION);
    return (*(get(function)->payload.stdlib_func))(s_expr, variables);
  }
}

Reference eval(Reference variables, Reference term) {
  if (get(term)->kind == STRING) {
    return pd_get(variables, term);
  } else if (get(term)->kind == LIST) {
    return execute(variables, term);
  }
  return term;
}

Reference eval_stdlib(Reference arguments, Reference state) {
  return eval(state, eval(state, get(get(arguments)->payload.child)->nextChild));
}

Reference lisp_function_call(Reference function, Reference s_expr,
                             Reference variables) {

  if (n_used > .9 * n_things) {
    //printf("pong\n");
    garbage_collect(0, 0);
  }

  callstack_assert(get(function)->kind == LISPFUNCTION);
  callstack_assert(get(variables)->kind == LIST);
  Reference inner_state = make_parent_dict(get(function)->payload.fbits.state);
  Reference name = get(get(function)->payload.fbits.inner_args)->payload.child;
  Reference value = get(get(s_expr)->payload.child)->nextChild;
  while (valid(name)) {
    callstack_assert(valid(value));
    callstack_assert(get(name)->kind == STRING);
    pd_set(inner_state, name, eval(variables, value));
    name = get(name)->nextChild;
    value = get(value)->nextChild;
  }
  return eval(inner_state, get(function)->payload.fbits.body);
}

Reference prints(Reference args, Reference state) {
  Reference child = get(args)->payload.child;
  child = get(child)->nextChild;
  while (valid(child)) {
    printf("%s ", get(child)->payload.string);
    child = get(child)->nextChild;
  }
  printf("%s", "\n");
  return thing_alloc();
}

void print_thing(Reference r) {
  static int indentation = 0;
  Thing thing = *get(r);

  switch (thing.kind) {
  case NUMBER:
    printf("%li", thing.payload.number);
    break;
  case STRING:
    printf("%s", thing.payload.string);
    break;
  case PARENTDICT:
    printf("parentdict");
  case LIST:
    printf("(");
    Reference child = thing.payload.child;
    while (valid(child)) {
      print_thing(child);
      child = get(child)->nextChild;
      if (valid(child)) {
        printf(" ");
      }
    }
    printf(")");
    break;
  case NOTHING:
    printf("nil");
    break;
  case LISPFUNCTION:
    printf("LISPFN");
    break;
  case STDLIBFUNCTION:
    printf("stdlibfnc");
    break;
  default:
    break;
  }
}

Reference printv(Reference args, Reference state) {
  arg_0(val) print_thing(val);
  return val;
}

Reference add(Reference args, Reference state) {
  arg_0(x) arg_1(y) return wrap_number(get(x)->payload.number + get(y)->payload.number);
}

Reference mul(Reference args, Reference state) {
  arg_0(x) arg_1(y) return wrap_number(get(x)->payload.number * get(y)->payload.number);
}

Reference gt(Reference args, Reference state) {
  arg_0(x) arg_1(y) return wrap_number(get(x)->payload.number > get(y)->payload.number);
}
Reference malloc_(Reference args, Reference state) {
  arg_0(size) return wrap_number((long)malloc(get(size)->payload.number));
}
Reference free_(Reference args, Reference state) {
  arg_0(ptr) free((void *)get(ptr)->payload.number);
  return wrap_number(0);
}
Reference peek8(Reference args, Reference state) {
  arg_0(ptr) return wrap_number(*((long *)get(ptr)->payload.number));
}
Reference poke8(Reference args, Reference state) {
  arg_0(ptr) arg_1(val) return wrap_number(*((long *)get(ptr)->payload.number) =
                                               get(val)->payload.number);
}
Reference peek4(Reference args, Reference state) {
  arg_0(ptr) return wrap_number(*((int *)get(ptr)->payload.number));
}
Reference peek(Reference args, Reference state) {
  arg_0(ptr) return wrap_number(*((char *)get(ptr)->payload.number));
}
Reference poke(Reference args, Reference state) {
  arg_0(ptr) arg_1(val) return wrap_number(*((char *)get(ptr)->payload.number) =
                                               get(val)->payload.number);
}

Reference dlopen_(Reference args, Reference state) {
	arg_0(libname) return wrap_number((long) dlopen(get(libname)->payload.string, 0));
}
Reference dlcall_(Reference args, Reference state) {
	arg_0(lib) arg_1(symbol) arg_2(inner_args)
		Reference (*function)(Reference, Reference, Thing*) = (Reference (*)(Reference, Reference, Thing*)) dlsym((void*)get(lib)->payload.number, get(symbol)->payload.string);
	       
		return function(inner_args, state, things);
}

Reference addr(Reference args, Reference state) {
  arg_0(val) return wrap_number((long)get(val));
}

Reference kind(Reference args, Reference state) {
  arg_0(thing) return wrap_number(get(thing)->kind);
}
Reference head(Reference args, Reference state) {
  arg_0(l) callstack_assert(get(l)->kind == LIST);
  return get(l)->payload.child;
}
Reference tail(Reference args, Reference state) {
  arg_0(lst)
  callstack_assert(get(lst)->kind == LIST);
  Reference t = get(get(lst)->payload.child)->nextChild;
  if (valid(t)) {
    Reference res = list();
    get(res)->payload.child = t;
    return res;
  } else {
    return thing_alloc();
  }
}

Reference locals(Reference args, Reference state) { return state; }

Reference cons(Reference args, Reference state) {
	arg_0(head)
	arg_1(rest_of_list)
  Reference res = list();
  add_child(res, head);
  callstack_assert(get(rest_of_list)->kind == LIST ||
                   get(rest_of_list)->kind == NOTHING);
  get(get(res)->payload.child)->nextChild = get(rest_of_list)->payload.child;
  return res;
}

Reference eq(Reference args, Reference state) {
  arg_0(a) arg_1(b) if (get(a)->kind != get(b)->kind) { return wrap_number(0); }
  switch (get(a)->kind) {
  case NUMBER:
    return wrap_number(get(a)->payload.number == get(b)->payload.number);
  case STRING:
    return wrap_number(streq(a, b));
  case NOTHING:
    return wrap_number(1);
  default:
    return wrap_number(0);
  }
}

Reference if_(Reference args, Reference state) {

  arg_0(condition)

  int branch;
  switch (get(condition)->kind) {
  case (NUMBER):
    branch = get(condition)->payload.number;
    break;
  case (LIST):
    branch = valid(get(condition)->payload.child);
    break;
  case (NOTHING):
    branch = 0;
    break;
  default:
    branch = 1;
    break;
  }
  Reference arg2 = get(get(get(args)->payload.child)->nextChild)->nextChild;
  Reference arg3 = get(arg2)->nextChild;

  if (branch) {
    return eval(state, arg2);
  } else {
    return eval(state, arg3);
  }
}

Reference setv(Reference args, Reference state) {
  arg_1(retval) pd_set(state,get( get(args)->payload.child)->nextChild, retval);
  return retval;
}

Reference defun(Reference args, Reference state) {
  Reference name = get(get(args)->payload.child)->nextChild;
  Reference inner_args = get(name)->nextChild;
  Reference body = get(inner_args)->nextChild;

  Reference lisp_function = thing_alloc();
  get(lisp_function)->kind = LISPFUNCTION;

  get(lisp_function)->payload.fbits.inner_args = inner_args;
  get(lisp_function)->payload.fbits.body = body;
  get(lisp_function)->payload.fbits.state = state;

  pd_set(state, name, lisp_function);
  return lisp_function;
}

Reference progn(Reference args, Reference state) {
  Reference arg = get(get(args)->payload.child)->nextChild;
  Reference res;
  while (valid(arg)) {
    res = eval(state, arg);
    arg = get(arg)->nextChild;
  }
  return res;
}
Reference input_raw(Reference args, Reference state) {
  char user_input[10000];
  char *tc = user_input;
  int success = scanf(" %9999[^\n]", tc);
if (success == -1) {
exit(0);
}
  char* result = malloc(strlen(user_input));
  strcpy(result, user_input);

  return wrap_number((long) result);

}

Reference parseList(char **nextchar);
Reference input_(Reference args, Reference state) {
  char user_input[10000];
  user_input[0] = '(';
  char *tc = user_input + 1;
  int paren_count = 0;
  do {
    paren_count = 0;

    int success = scanf(" %9999[^\n]", tc);
    if (success == -1) {
      exit(0);
    }
    tc = user_input + 1;
    while (*tc) {
      if (*tc == '(')
        ++paren_count;
      if (*tc == ')')
        --paren_count;
      tc++;
    }
  } while (paren_count);
  *tc = ')';
  tc = user_input;

  return get(parseList(&tc))->payload.child;
}
Reference quote(Reference args, Reference state) { return get(get(args)->payload.child)->nextChild; }

Reference trampoline(Reference args, Reference state) {
  //(progn
  //  (defun print_hello_n_times (i)
  //    (progn
  //       (prints hello)
  //       (if (= i 1) nil (cons (quote bounce) (cons (cons (- i 1) nil) nil)))
  //    )
  //  )
  //  (trampoline print_hello_n_times (cons 200 nil))
  //)
  Reference function_name = get(args)->payload.child;
  Reference args_to_pass = eval(state, get(function_name)->nextChild);

  Reference function = eval(state, function_name);

  int do_it_again = 0;
  Reference ret;
  int first = 1;
  do {
    do_it_again = 0;

    callstack_assert(get(function)->kind == LISPFUNCTION);
    callstack_assert(get(state)->kind == LIST);
    Reference inner_state = make_parent_dict(get(function)->payload.fbits.state);
    Reference name = get(get(function)->payload.fbits.inner_args)->payload.child;
    Reference value = get(args_to_pass)->payload.child;
    while (valid(name)) {
      callstack_assert(get(name)->kind == STRING);
      if (first) {
      pd_set(inner_state, name, eval(state, value));
      } else {
      pd_set(inner_state, name, value);
      }
      name = get(name)->nextChild;
      value = get(value)->nextChild;
    }
    ret = eval(inner_state, get(function)->payload.fbits.body);
    if (get(ret)->kind == LIST) {
      if (streq(get(ret)->payload.child, wrap_string("bounce"))) {
        do_it_again = 1;
        args_to_pass = get(get(ret)->payload.child)->nextChild;
      }
    }
    first = 0;

  } while (do_it_again);
  return ret;
}

Reference wrap_stdlib(Reference (*libfunc)(Reference, Reference)) {
  Reference result = thing_alloc();
  get(result)->kind = STDLIBFUNCTION;
  get(result)->payload.stdlib_func = libfunc;
  return result;
}

Reference _get_slot(int i) { 

  if (i < 0 || i>= n_things) {
    return 0;
  }
	
	return makeref(i, things[i].generation); }

void mark_used(Reference r) {
  if (get(r)->in_use) {
    return;
  }
  while (valid(r)) {
  get(r)->in_use = 1;
  Thing *t = get(r);
  if (valid(t->payload.fbits.body))
    mark_used(t->payload.fbits.body);
  if (valid(t->payload.child))
    mark_used(t->payload.child);
  if (valid(t->payload.fbits.inner_args))
    mark_used(t->payload.fbits.inner_args);
  if (valid(t->payload.fbits.state))
    mark_used(t->payload.fbits.state);
  r = t->nextChild;
  }
}
long *stack_top;

__attribute__((noinline))
Reference garbage_collect(Reference args, Reference state) {
  long yeeter = 0;
  long *stack_bottom = &yeeter;

  for (int i = 2; i < n_things; i++) {
    Reference r = _get_slot(i);
    get(r)->in_use = 0;
  }

  for (long *candidate = stack_bottom; candidate < stack_top; candidate += 1) {
    Reference r = *((Reference *)(candidate));
    r = _get_slot(idx(r));
    if (valid(r)) {
      if (idx(r)!= 1) {
        mark_used(r);
      }
    }
  }
  for (int i = 2; i < n_things; i++) {
    Reference r = _get_slot(i);
    if (get(r)->kind != FREE && !get(r)->in_use) {
      thing_free(r);
    }
  }
  // for (int i = 2; i < 200; i++) {
  //        Reference r = _get_slot(i);
  //        printf("%i  |  ", get(r)->in_use);
  //        print_thing(_get_slot(i));
  //        printf("\n");
  // }
  return thing_alloc();
}

char *read_file(const char *a);
Reference readfile(Reference args, Reference state) {
  callstack_assert(get(get(get(args)->payload.child)->nextChild)->kind == STRING);
  char *filename = get(get(get(args)->payload.child)->nextChild)->payload.string;
  char *program_file = read_file(filename);

  char **nc = &program_file;

  Reference program = parseList(nc);
  return program;
}
Reference read_file_raw(Reference args, Reference state) {
  arg_0(filename);
  return wrap_number((long)read_file(get(filename)->payload.string));
}

Reference make_stdlib() {
  Reference stdlib = make_parent_dict(0);

  pd_set(stdlib, wrap_string("printv"), wrap_stdlib(&printv));
  pd_set(stdlib, wrap_string("prints"), wrap_stdlib(&prints));
  pd_set(stdlib, wrap_string("setv"), wrap_stdlib(&setv));
  pd_set(stdlib, wrap_string("progn"), wrap_stdlib(&progn));
  pd_set(stdlib, wrap_string("*"), wrap_stdlib(&mul));
  pd_set(stdlib, wrap_string(">"), wrap_stdlib(&gt));
  pd_set(stdlib, wrap_string("malloc"), wrap_stdlib(&malloc_));
  pd_set(stdlib, wrap_string("free"), wrap_stdlib(&free_));
  pd_set(stdlib, wrap_string("peek"), wrap_stdlib(&peek));
  pd_set(stdlib, wrap_string("poke"), wrap_stdlib(&poke));
  pd_set(stdlib, wrap_string("peek4"), wrap_stdlib(&peek4));
  pd_set(stdlib, wrap_string("peek8"), wrap_stdlib(&peek8));
  pd_set(stdlib, wrap_string("poke8"), wrap_stdlib(&poke8));
  pd_set(stdlib, wrap_string("addr"), wrap_stdlib(&addr));
  pd_set(stdlib, wrap_string("+"), wrap_stdlib(&add));
  pd_set(stdlib, wrap_string("="), wrap_stdlib(&eq));
  pd_set(stdlib, wrap_string("if"), wrap_stdlib(&if_));
  pd_set(stdlib, wrap_string("defun"), wrap_stdlib(&defun));
  pd_set(stdlib, wrap_string("quote"), wrap_stdlib(&quote));
  pd_set(stdlib, wrap_string("head"), wrap_stdlib(&head));
  pd_set(stdlib, wrap_string("kind"), wrap_stdlib(&kind));
  pd_set(stdlib, wrap_string("tail"), wrap_stdlib(&tail));
  pd_set(stdlib, wrap_string("locals"), wrap_stdlib(&locals));
  pd_set(stdlib, wrap_string("cons"), wrap_stdlib(&cons));
  pd_set(stdlib, wrap_string("garbage-collect"), wrap_stdlib(&garbage_collect));
  pd_set(stdlib, wrap_string("trampoline"), wrap_stdlib(&trampoline));
  pd_set(stdlib, wrap_string("nil"), thing_alloc());
  pd_set(stdlib, wrap_string("input"), wrap_stdlib(&input_));
  pd_set(stdlib, wrap_string("inputraw"), wrap_stdlib(&input_raw));
  pd_set(stdlib, wrap_string("eval"), wrap_stdlib(&eval_stdlib));
  pd_set(stdlib, wrap_string("readfile"), wrap_stdlib(&readfile));
  pd_set(stdlib, wrap_string("readfileraw"), wrap_stdlib(&read_file_raw));
  return stdlib;
}

Reference parseList(char **nextchar) {
  if (**nextchar == '#') {
    while (**nextchar != '(') {
      ++*nextchar;
    }
  }
  Reference result = list();
  assert(**nextchar == '(');
  ++*nextchar;
  while (**nextchar != ')') {
    char c = **nextchar;
    if (is_string(c)) {
      append_child(result, parse_string(nextchar));
    } else if (c >= '0' && c <= '9') {
      append_child(result, parse_number(nextchar));
    } else if (c == '(') {
      append_child(result, parseList(nextchar));
    } else if (!c) {
      callstack_assert("MISSING PAREN" == 0);
    } else {
      ++*nextchar;
    }
  }
  ++*nextchar;
  return result;
}
char *read_file(const char *path) {
  FILE *f = fopen(path, "rb");
  if (!f)
    return NULL;

  fseek(f, 0, SEEK_END);
  long len = ftell(f);
  rewind(f);

  char *buf = malloc(len + 1);
  if (!buf) {
    fclose(f);
    return NULL;
  }

  fread(buf, 1, len, f);
  buf[len] = '\0';
  fclose(f);
  return buf;
}

int progmain();
int mainmain();
int setupgc() {
  long yooter = 0;
  stack_top = &yooter;
  return mainmain();
}
__attribute__((noinline))
int mainmain() {
  freelist = setup_freelist();
  return progmain();

}

long car__(long list) {
	Reference list_r = (Reference) list;
	return get(list_r)->payload.child;
}
long cdr__(long list) {
	Reference list_r = (Reference) list;
	return get(list_r)->nextChild;
}
long cons__(long car, long cdr) {
  Reference res = list();
  get(res)->payload.child = car;
  get(res)->nextChild = cdr;
  return res;
}

