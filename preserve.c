#include <Rdefines.h>

SEXP
R_setFinalizer(SEXP obj, SEXP fun)
{
    R_RegisterFinalizer(obj, fun);
    return(R_NilValue);
}   
