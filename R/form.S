
getForm =
  #
  # The ... here are for the arguments to the form, not the curl options.
  #
  #
function(uri, ..., .params = character(), .opts = list(), curl = getCurlHandle())  
{
    # should we merge params with ....
    # for now just one or the other.  
  if(missing(.params)) {
    .params = list(...)
  }

  if(length(.params) == 0) 
       warning("No inputs passed to form")
  else if(missing(.opts))
    testCurlOptionsInFormParameters(.params)
  
    # Convert the arguments into a URL string.
  els = sapply(names(.params), function(n) {
                              # turn name=c("a", "b") into
                              #  name=a&name=b
                                paste(n, curlEscape(.params[[n]]), sep="=", collapse="&")
                               })

   args = paste(els, collapse="&")

   uri = paste(uri, args, sep="?")

   getURI(uri, .opts = .opts)
}

testCurlOptionsInFormParameters =
function(.params)
{
  if(any( w <- names(.params) %in% listCurlOptions())) {
    warning("Found possible curl options in form parameters: ", paste(names(.params)[w], collapse = ", "))
    TRUE
  } else
    FALSE
}


PostStyles = c('HTTPPOST' = NA,
               'POST' = as.integer(47))

postForm =
  #
  # The ... here are for the arguments to the form, not the curl options.
  #
  #
function(uri, ...,
         .params = list(), .opts = curlOptions(url = uri),
         curl = getCurlHandle(), style = 'HTTPPOST')
{
  isProtected = missing(curl)
  write = NULL
  noCurlOptions = missing(.opts)

  if(!is.na(style)) {
      if(is.character(style)) {
        i = pmatch(tolower(style), tolower(names(PostStyles)))
        if(is.na(i))
          stop("POST style is not recognized: must be one of ", paste(names(PostStyles), collapse = ", "))
        style = as.integer(PostStyles[i])
      } else {
        if(!(style %in% PostStyles))
          warning("Unrecognized style value ", style)
        style = as.integer(style)
      }
    }
  
   # merge the two sources of inputs
  .params = merge(list(...), .params)

  
  # Need to organize the types here into a structure.

 if(!"writefunction" %in% names(.opts)) {
   write = basicTextGatherer()
   .opts[["writefunction"]] = write[[1]]
 }

  # Force the curlOptions to be resolved at this point, but not set.

  .opts = curlSetOpt(url = uri, .opts = .opts, curl = NULL)

  
#  curlOptions[["httpost"]] <- .params
#  curlPerform(curl, .opts = curlOptions)

   if(!is.na(style) && style == PostStyles['POST']) {
     tmp = as.list(.params)
     .params = paste(
                  sapply(names(tmp),
                         function(id)
                             paste(id, curlEscape(tmp[[id]]), sep = "=")),
                  collapse = "&")
            
   } else
     .params = as.list(.params)
  

  if(length(.params) == 0) {
    postfields = getCurlOptionsConstants()["postfields"]
    if(!(postfields  %in% .opts$ids))
      warning("No inputs passed to form")
  } else if(noCurlOptions)
    testCurlOptionsInFormParameters(.params)
  
  status = .Call("R_post_form", curl, .opts, .params, TRUE, as.integer(style),  PACKAGE = "RCurl")

  if(!isProtected) {
     # Reset the httppost field to NULL so we can release the values.
     # curlSetOpt(httppost = FALSE, curl = curl)
     curlSetOpt(httpget = TRUE, curl = curl)
  }
  
  if(!is.null(write)) {
    write[[2]]()
  }
  #XXX what if write is NULL - what do we return?
}  



fileUpload =
function(filename = character(), contents = character(), contentType = character())
{
  if(length(contents) == 0 && !file.exists(filename))
     stop("specified file does not exist: ", filename, ".  You must specify a valid file name or provide the contents to send.")

  filename = path.expand(filename)

  if(!typeof(contents) == "raw")
     contents = as.character(contents)
  
  structure(list(filename = as.character(filename),
                 contents = contents,
                 contentType = as.character(contentType)),
            class = "FileUploadInfo")
}  
