#ifndef R_CURL_H
#define R_CURL_H

#include <curl/curl.h>
#include <curl/easy.h>
#include <curl/types.h> /* Is this needed? */
#include <Rdefines.h>

/*
#define RCURL_DEBUG_MEMORY 1
*/

typedef struct _RCurlMemory  RCurlMemory;

struct _RCurlMemory {

	CURL *curl;  /* the CURL object for which this data was allocated.*/
	void *data;  /* the data */
	CURLoption option;  /* the option, so we can tell what it was for.*/

	RCurlMemory *next;
};

typedef struct _CURLOptionMemoryManager CURLOptionMemoryManager;

struct _CURLOptionMemoryManager {
	CURL *curl;
	RCurlMemory *top;

	int numTickets; /* Number of entries in the top. Used for debugging here. */

	CURLOptionMemoryManager *next;
	CURLOptionMemoryManager *last;
};

RCurlMemory *RCurl_addMemoryAllocation(CURLoption, void *, CURL *);
CURLOptionMemoryManager *RCurl_addMemoryTicket(RCurlMemory *);
void RCurl_releaseMemoryTickets(CURL *curl);
CURLOptionMemoryManager* RCurl_getMemoryManager(CURL *curl);




SEXP R_curl_easy_setopt(SEXP handle, SEXP values, SEXP opts, SEXP isProtected);
SEXP R_curl_easy_init(void);
SEXP R_curl_easy_duphandle(SEXP);
SEXP R_curl_global_cleanup();
SEXP R_curl_global_init(SEXP);
SEXP R_curl_version_info(SEXP flag);
SEXP R_curl_easy_perform(SEXP handle, SEXP opts, SEXP isProtected);
SEXP R_curl_easy_getinfo(SEXP handle, SEXP which);
SEXP R_curl_escape(SEXP vals, SEXP escape);
SEXP R_post_form(SEXP handle, SEXP opts, SEXP params, SEXP isProtected);

SEXP R_getCURLErrorEnum(void);
SEXP R_getCURLInfoEnum(void);
SEXP R_getCURLOptionEnum(void);

#endif
