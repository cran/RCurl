#include "Rcurl.h"

/* Not available from the curl headers.  Are they are not (?) exported in the library on all
   platforms or do we have to pull the code in here.  See the license discussion
   about this.
*/

/*
 Should we work with RAW objects here.
*/

#include <stdlib.h>

SEXP
R_base64_decode(SEXP r_text, SEXP asRaw)
{
  char *text;
  unsigned char *ans;
  size_t len;
  SEXP r_ans;
  
  if(TYPEOF(r_text) == STRSXP)
    text = (char *) CHAR(STRING_ELT(r_text, 0)); // used read-only
  else {
      // RAW() is not null-terminated
      // text = RAW(r_text);
      len = LENGTH(r_text);
      text = R_alloc(len+1, 1); text[len] = '\0';
      memcpy(text, RAW(r_text), len);
  }

  len = R_Curl_base64_decode(text, &ans);

  if(len < 1) {
      Rf_error("decoding from base64 failed");
  }


  if(INTEGER(asRaw)[0]) {
     r_ans = allocVector(RAWSXP, len);
     memcpy(RAW(r_ans), ans, len);
  } else {
    r_ans = mkString((char *) ans);
  }
// LENGTH cannot be negative
//  if(ans && len > -1)
   if(ans) free(ans);

  return(r_ans);
}


SEXP
R_base64_encode(SEXP r_text, SEXP asRaw)
{
  const char *text;
  char *ans;
  size_t len, n;
  SEXP r_ans;

  if(TYPEOF(r_text) == STRSXP) {
    text = CHAR(STRING_ELT(r_text, 0));
    n = strlen(text);
  } else {
    text = (const char *) RAW(r_text);
    n = Rf_length(r_text);
  }

  len = R_Curl_base64_encode(text, n, &ans);

  if(len == -1) {
      Rf_error("failed to encode the data");
  }
  if(INTEGER(asRaw)[0]) {
     r_ans = allocVector(RAWSXP, len);
     memcpy(RAW(r_ans), ans, len);
  } else {
    r_ans = mkString(ans);
  }
  free(ans);

  return(r_ans);
}
