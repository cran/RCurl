getForm =
  #
  # The ... here are for the arguments to the form, not the curl options.
  #
  #
function(uri, ..., .params = character(), curlOptions = list(), curl = getCurlHandle())  
{
    # should we merge params with ....
    # for now just one or the other.  
  if(missing(.params)) {
    .params = list(...)
  }

    # Convert the arguments into a URL string.
  els = sapply(names(.params), function(n) {
                              # turn name=c("a", "b") into
                              #  name=a&name=b
                                paste(n, .params[[n]], sep="=", collapse="&")
                               })

   args = paste(els, collapse="&")

   uri = paste(uri, args, sep="?")

   getURL(uri, .opts = curlOptions)
}



postForm =
  #
  # The ... here are for the arguments to the form, not the curl options.
  #
  #
function(uri, ..., .params = list(), .opts = curlOptions(url = uri), curl = getCurlHandle())  
{
  isProtected = missing(curl)
  write = NULL
  
   # merge the two sources of inputs
  .params = merge(list(...), .params)

  # Need to organize the types here into a structure.


 if(!"writefunction" %in% names(.opts)) {
   write = basicTextGatherer()
   .opts[["writefunction"]] = write[[1]]
 }

  # Force the curlOptions to be resolved at this point, but not set.

  .opts = curlSetOpt(.opts = .opts, curl = NULL)

  
#  curlOptions[["httpost"]] <- .params
#  curlPerform(curl, .opts = curlOptions)

  .params = as.list(.params)
  
  status = .Call("R_post_form", curl, .opts, .params, TRUE,  PACKAGE = "RCurl")

  if(!isProtected) {
     # Reset the httppost field to NULL so we can release the values.
     # curlSetOpt(httpget = TRUE, cur = curl)
     curlSetOpt(httppost = NULL, cur = curl)
  }
  
  if(!is.null(write)) {
    write[[2]]()
  }
}  


