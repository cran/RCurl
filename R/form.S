
getForm =
  #
  # The ... here are for the arguments to the form, not the curl options.
  #
  #
function(uri, ..., .params = character(), .opts = list(), curl = getCurlHandle(), .encoding = integer(), binary = NA,
          .checkParams = TRUE)  
{
    # should we merge params with ....
    # for now just one or the other.  
  if(missing(.params)) {
    .params = list(...)
  }

  if(length(.params) == 0) 
       warning("No inputs passed to form")
  else if(missing(.opts) && .checkParams)
    testCurlOptionsInFormParameters(.params)
  
    # Convert the arguments into a URL string.
  els = sapply(names(.params), function(n) {
                              # turn name=c("a", "b") into
                              #  name=a&name=b
                                paste(n, curlEscape(.params[[n]]), sep="=", collapse="&")
                               })

   args = paste(els, collapse="&")

   uri = paste(uri, args, sep="?")

   getURLContent(uri, .opts = .opts, .encoding = .encoding, binary = binary, curl = curl)
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
         curl = getCurlHandle(), style = 'HTTPPOST',
         .encoding = integer(), binary = NA, .checkParams = TRUE,
         .contentEncodeFun = curlEscape) # Should probably be curlPercentEncode !
{
  isProtected = missing(curl)
  write = NULL
  noCurlOptions = missing(.opts)

  if(!is.na(style)) {
      # The style of the post, i.e. HTTPPOST or regular POST,
      # i.e. www-form-encoded or
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

 hasOwnWrite = "writefunction" %in% names(.opts)

 buf = NULL
 header = basicTextGatherer()
 if(!hasOwnWrite) {
   # write = basicTextGatherer()
   if(FALSE) {
     .len = 5000L
     write = basicTextGatherer()
     .opts[["writefunction"]] = getNativeSymbolInfo("R_curl_write_binary_data")$address
     buf = binaryBuffer(.len)
     .opts[["file"]] = buf@ref
     .opts[["headerfunction"]] = header$update
   } else {
     write = dynCurlReader(curl, verbose = FALSE, binary = binary, baseURL = uri)
     # .opts[["writefunction"]] = write$update
     .opts[["headerfunction"]] = write$update     
   }

#   .opts[["writefunction"]] = write$update
 }

  # Force the curlOptions to be resolved at this point, but not set.
  optionNames = names(.opts)

  .opts = curlSetOpt(url = uri, .opts = .opts, curl = NULL, .encoding = .encoding)

#  curlOptions[["httpost"]] <- .params
#  curlPerform(curl, .opts = curlOptions)

   if(!is.na(style) && style == PostStyles['POST']) {
     tmp = as.list(.params)
     .params = paste(
                  sapply(names(tmp),
                         function(id)
                             paste(id, .contentEncodeFun(tmp[[id]]), sep = "=")),
                  collapse = "&")
            
   } else
     .params = as.list(.params)
  

  if(length(.params) == 0) {
    postfields = getCurlOptionsConstants()["postfields"]
    if(!(postfields  %in% .opts$ids))
      warning("No inputs passed to form")
  } else if(noCurlOptions && .checkParams)
    testCurlOptionsInFormParameters(.params)
  
  status = .Call("R_post_form", curl, .opts, .params, TRUE, as.integer(style),  PACKAGE = "RCurl")

  if(!isProtected) {
     # Reset the httppost field to NULL so we can release the values.
     # curlSetOpt(httppost = FALSE, curl = curl)
     curlSetOpt(httpget = TRUE, curl = curl)
  }

  if(!is.null(buf)) {
    processContent( as(buf, "raw"), header, .encoding)
  } else  if(!is.null(write)) 
    write$value()

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
