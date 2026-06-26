
#include "prelude.lisp"

(defun Unit () ((sentinel Unit)))
(defun (print Unit) () 0)
(header ((typenameof TYPE)) String)

(defun ((cases A B C D E F)) () ((cast (CasesClause A B C D E F)) 0))
(defun ((cases A B C D E F G H I)) () ((cast (CasesClause A B C D E F G H I)) 0))



(defun ((set NAME) VTYPE SDICT) (value dict) 
  ((cast (SDict NAME VTYPE SDICT)) (cons_ ((cast I64) value) ((cast I64) dict))))

(defun ((apply BODY) Unit) (closure) BODY)
(defun ((apply BODY) (SDict NAMEONE VONETYPE Unit)) (closure) 
  (( \ NAMEONE . BODY) ((cast VONETYPE) (car_ ((cast I64) closure)))))

(defun ((apply BODY) (SDict NAMEONE VONETYPE (SDict NAMETWO VTWOTYPE Unit))) (closure) 
  (( \ NAMEONE NAMETWO . BODY) 
   ((cast VONETYPE) (car_ ((cast I64) closure)))
   ((cast VTWOTYPE) ((car_ . cdr_) ((cast I64) closure)))
		    ))
(defun ((apply BODY) (SDict NAMEONE VONETYPE 
			    (SDict NAMETWO VTWOTYPE 
				   (SDict NAMETHREE VTHREETYPE Unit)))) (closure) 
  (( \ NAMEONE NAMETWO NAMETHREE . BODY) 
   ((cast VONETYPE) (car_ ((cast I64) closure)))
   ((cast VTWOTYPE) ((car_ . cdr_) ((cast I64) closure)))
   ((cast VTHREETYPE) ((car_ . cdr_ . cdr_) ((cast I64) closure)))
		    ))
(defun ((apply BODY) (SDict NAMEONE VONETYPE 
			    (SDict NAMETWO VTWOTYPE 
				   (SDict NAMETHREE VTHREETYPE 
					  (SDict NAMEFOUR VFOURTYPE Unit))))) (closure) 
  (( \ NAMEONE NAMETWO NAMETHREE NAMEFOUR . BODY) 
   ((cast VONETYPE) (car_ ((cast I64) closure)))
   ((cast VTWOTYPE) ((car_ . cdr_) ((cast I64) closure)))
   ((cast VTHREETYPE) ((car_ . cdr_ . cdr_) ((cast I64) closure)))
   ((cast VFOURTYPE) ((car_ . cdr_ . cdr_ . cdr_) ((cast I64) closure)))
		    ))


(defun ((app_doit ARGS) ARGS) )
(defun ((app_uncons ARGS)))
(defun ((app_impl)    ))
(defun ((app    )    ))


#define ENUM2(TYPENAME, NAMEONE, TYPEONE, NAMETWO, TYPETWO)                                                         \
(defun (NAMEONE) () (NAMEONE (Unit)))                                                                               \
(defun (NAMEONE TYPEONE) (payload) ((cast TYPENAME) (cons_ 0 ((cast I64) payload))))                                \
(defun (NAMETWO) () (NAMETWO (Unit)))                                                                               \
(defun (NAMETWO TYPETWO) (payload) ((cast TYPENAME) (cons_ 1 ((cast I64) payload))))                                \
(defun (match TYPENAME (CasesClause NAMEONE ARGONE BODYONE NAMETWO ARGTWO BODYTWO) CLOSURETYPE) (value _ closure)    \
  (if (= 0 (car_ ((cast I64) value)))                                                                               \
    ((apply BODYONE) ((set ARGONE) ((cast TYPEONE) (cdr_ ((cast I64) value))) closure))                             \
    ((apply BODYTWO) ((set ARGTWO) ((cast TYPETWO) (cdr_ ((cast I64) value))) closure))                             \
					  ))                                                                        \
(defun (match TYPENAME THENCLAUSE) (value _) (match value _ (Unit)))


#define ENUM3(TYPENAME, NAMEONE, TYPEONE, NAMETWO, TYPETWO, NAMETHREE, TYPETHREE)                                    \
(defun (NAMEONE) () (NAMEONE (Unit)))                                                           \
(defun (NAMEONE TYPEONE) (payload) ((cast TYPENAME) (cons_ 0 ((cast I64) payload))))            \
(defun (NAMETWO) () (NAMETWO (Unit)))                                                           \
(defun (NAMETWO TYPETWO) (payload) ((cast TYPENAME) (cons_ 1 ((cast I64) payload))))            \
(defun (NAMETHREE) () (NAMETHREE (Unit)))                                                           \
(defun (NAMETHREE TYPETHREE) (payload) ((cast TYPENAME) (cons_ 2 ((cast I64) payload))))            \
(defun (match TYPENAME (CasesClause NAMEONE ARGONE BODYONE NAMETWO ARGTWO BODYTWO NAMETHREE ARGTHREE BODYTHREE) CLOSURETYPE)   \
  (value _ closure)                       \
  (if (= 0 (car_ ((cast I64) value)))                                                                               \
    ((apply BODYONE) ((set ARGONE) ((cast TYPEONE) (cdr_ ((cast I64) value))) closure))                             \
    (if (= 1 (car_ ((cast I64) value)))                                                                               \
      ((apply BODYTWO) ((set ARGTWO) ((cast TYPETWO) (cdr_ ((cast I64) value))) closure))                             \
      ((apply BODYTHREE) ((set ARGTHREE) ((cast TYPETHREE) (cdr_ ((cast I64) value))) closure))                             \
					  )))                                                                       \
(defun (match TYPENAME THENCLAUSE) (value _) (match value _ (Unit)))

ENUM2(HoSi,  Ho, I64, Si, String)

(print (match (Si "poo") ((cases 
			    Ho _ 0 
			    Si _ 1))))

(defun ((uncons (A Unit))) () ((sentinel (A))))
(defun ((uncons (A (B Unit)))) () ((sentinel (A B))))
(defun ((uncons (A (B (C Unit))))) () ((sentinel (A B C))))
(defun ((uncons (A (B (C (D Unit)))))) () ((sentinel (A B C D))))

(defun ((conslist ())) () ((sentinel Unit)))
(defun ((conslist (A))) () ((sentinel (A Unit))))
(defun ((conslist (A B))) () ((sentinel (A (B Unit)))))
(defun ((conslist (A B C))) () ((sentinel (A (B (C Unit))))))
(defun ((conslist (A B C D))) () ((sentinel (A (B (C (D Unit)))))))
(defun ((conslist (A B C D E))) () ((sentinel (A (B (C (D (E Unit))))))))
(defun ((conslist (A B C D E F))) () ((sentinel (A (B (C (D (E (F Unit)))))))))

(print ((apply y) ((set y) 4 ((set x) 3 (Unit)))))
(print 
  ((let x) 100 ((then
		  (match (Si "poo") ((cases 
			    Ho _ 0 
			    Si _ x))
			 ((set x) x (Unit)))))))
