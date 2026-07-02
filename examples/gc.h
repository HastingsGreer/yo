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
    fflush(stdout); \
    printf("\n"); callstack();                                                               \
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
	LIST, FREE
} Kind;

typedef long Reference;

#define idx(Reference) (Reference & 0xFFFFFF)

#define generation(Reference) (Reference >> 24)

#define makeref(idx, generation) (idx + (((long)generation) << 24))


typedef struct Thing {
  Kind kind;
  char generation;
  char in_use;
  Reference nextChild;
  Reference child;
} Thing;
#define n_things 500000

Thing *get(Reference ref);
int valid(Reference ref); 
Reference claim(Reference ref); 
Reference setup_freelist(); 
Reference thing_alloc(); 
void free_add_child(Reference parent, Reference child); 
void thing_free(Reference thing); 

Reference list(); 

//Garbage Collector
Reference _get_slot(int i); 
void mark_used(Reference r); 
Reference garbage_collect(Reference args, Reference state); 

int setupgc();
long car__(long list);
long cdr__(long list);
long cons__(long car, long cdr);

#endif
