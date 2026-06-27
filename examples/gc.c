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
  get(freelist_holder_ref)->child = claim(makeref(2l, 0l));
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
  Reference result = get(freelist)->child;
  callstack_assert(idx(result));
  if (!valid(get(result)->nextChild)) {
    printf("ping\n");
    garbage_collect(0, 0);
    result = get(freelist)->child;
  }
  get(freelist)->child = get(result)->nextChild;
  return claim(result);
}

void free_add_child(Reference parent, Reference child) {
  get(child)->nextChild = get(parent)->child;
  get(parent)->child = child;
  get(child)->kind = FREE;
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
  if (valid(t->child))
    mark_used(t->child);
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
	return get(list_r)->child;
}
long cdr__(long list) {
	Reference list_r = (Reference) list;
	return get(list_r)->nextChild;
}
long cons__(long car, long cdr) {
  Reference res = list();
  get(res)->child = car;
  get(res)->nextChild = cdr;
  return res;
}

