
curlGlobalInit =
function(flags = c("ssl", "win32")) # This is the same as all.
{
  status = .Call("R_curl_global_init", setBitIndicators(flags, CurlGlobalBits), PACKAGE = "RCurl")

  asCurlErrorCode(status)
}

curlGlobalCleanup =
function()
{
.Call("R_curl_global_cleanup", PACKAGE = "RCurl")
}  

asCurlErrorCode =
function(val)
{
  defs =.Call("R_getCURLErrorEnum", PACKAGE = "RCurl")
  defs[defs == val]
}


debugGatherer =
function()
{
  els = NULL
  
  update = function(msg, type, curl)  {
    els[[type + 1]] <<- c(els[[type + 1]], msg)
    0
  }

  reset = function() { els <<-
                         list(text=character(),
                              headerIn = character(),
                              headerOut = character(),
                              dataIn = character(),
                              dataOut = character())
                     }

  ans = list(update = update,
             value = function(collapse="", ...) {
                         if(is.null(collapse))
                           return(els)
                                 
                         sapply(els, function(x) paste(x, collapse = collapse, ...))
                       },
             reset = reset)


  class(ans) <- c("RCurlDebugHandler", "RCurlCallbackFunction")

  ans$reset()
  
  ans
}

  


basicTextGatherer =
  #
  # This is a function that is used to create a closure (i.e. a function with its own local variables
  # whose values persist across invocations).  This is called to provide an instance of a function that is
  # called when the libcurl engine has some text to be processed as it is reading the HTTP response from the
  # server.
  # The function that reads the text can do whatever it wants with it. This one simply
  # cumulates it and makes it available via a second function. 
  #
function(txt = character())
{
  update = function(str) {
    txt <<-   c(txt, str)
    nchar(str)
  }

  reset = function() {  txt <<- character() }

  ans = list(update = update,
             value = function(collapse="", ...) {
                         if(is.null(collapse))
                             return(txt)
                                  
                         paste(txt, collapse = collapse, ...)
                      },
              reset = reset)

  class(ans) <- c("RCurlTextHandler", "RCurlCallbackFunction")
  
  ans$reset()
  
  ans
}

getURL =
  #
  # initializes a curl handle, populates its settings
  #
  #
function(url, ..., write = basicTextGatherer(), curl = getCurlHandle())
{
#    write = getNativeSymbolInfo("R_curl_write_data", PACKAGE = "httpClient")$address

  returnWriter = FALSE
  if(missing(write) || inherits(write, "RCurlCallbackFunction")) {
    writeFun = write$update
  } else {
      writeFun = write
      returnWriter = TRUE
  }

    # Don't set them, just compute them.
  opts = curlOptions(URL = url, writefunction = writeFun, ...)

  status = curlPerform(curl = curl, .opts = opts)

  if(returnWriter)
    return(write)
  
  write$value()
}

curlPerform =
function(..., .opts = list(), curl = getCurlHandle())
{
  isProtected = missing(curl)

  .opts = curlSetOpt(..., .opts = .opts, curl = NULL)

    # The 3rd argument - TRUE - is just so that we don't need to create it in the
    # C code to pass to R_curl_easy_setopt.

  status = .Call("R_curl_easy_perform", curl, .opts,  isProtected, PACKAGE = "RCurl")

  asCurlErrorCode(status)
}  

  

curlSetOpt =
  #
  # This is used when setting the values globally.
  #
  # No sense in generating a default CURL handle and then throwing
  # it way.  It is only here to allow people to create it in a call
  # when they set the options.
  # This could go as most people will call this having already created
  # the CURL object.
function(..., .opts = list(), curl = getCurlHandle())
{
 .opts = curlOptions(..., .opts = .opts)

  if("httpheader" %in% names(.opts)) {
    tmp  = .opts[["httpheader"]]

      # paste the name and value together if
      # a) we have names, and b) not all entries have a :
    if(length(names(tmp)) && length(grep(":", tmp)) != length(tmp))
      .opts[["httpheader"]] = paste(names(tmp), tmp, sep = ": ")
  }
 
  if(length(.opts)) {
     optIds = mapCurlOptNames(names(.opts))

          # Check the types

     if(!is.null(curl)) {
       status = .Call("R_curl_easy_setopt", curl, .opts, optIds, FALSE, PACKAGE = "RCurl")
       return(curl)
     }
  } else
     optIds = integer()

 
 tmp = list(ids = optIds, values = .opts)
 class(tmp) <- "ResolvedCURLOptions"
 tmp
}


getCurlHandle =
function(..., .opts = NULL)
{
 h = .Call("R_curl_easy_init", PACKAGE = "RCurl")

 curlSetOpt(..., .opts = .opts, curl = h)
 
 h
}

dupCurlHandle =
function(curl, ..., .opts = NULL)
{
 h = .Call("R_curl_easy_duphandle", curl, PACKAGE = "RCurl")

 curlSetOpt(..., .opts = .opts, curl = h)

 h
}


curlEscape =
function(urls)
{
   .Call("R_curl_escape", as.character(urls), TRUE, PACKAGE = "RCurl")
}


curlUnescape =
function(urls)
{
   .Call("R_curl_escape", as.character(urls), FALSE, PACKAGE = "RCurl")
}   
