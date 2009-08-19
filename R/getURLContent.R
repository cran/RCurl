getURLContent =
  #
  # Used to be
  #  header = basicTextGatherer()  
  #  ans = getBinaryURL(url, headerfunction = header$update, curl = header$curl())
  #  processContent(ans, header$header(), .encoding)
  # but now we use the dynamic reader.
  #
function(url, ..., curl = getCurlHandle(.opts), .encoding = NA, binary = NA, .opts = list(...),
         header = dynCurlReader(curl, binary = binary))
{
  if(!missing(curl))
     curlSetOpt(.opts = .opts, curl = curl)
  
  curlPerform(url = url, headerfunction = header$update, curl = curl, .opts = .opts)
  http.header = parseHTTPHeader(header$header())
  stop.if.HTTP.error(http.header)
  
  header$value()
}

stop.if.HTTP.error = 
function(http.header)
{  
  if( floor(as.integer(http.header[["status"]])/100) == 4) {
     klass =  RCurl:::getHTTPErrorClass(http.header[["status"]])
     err = simpleError(http.header[["statusMessage"]])
     class(err) = c(klass, class(err))
     #signalCondition(err)
     stop(err)
  }

  TRUE
}

processContent = 
#
# Figure out how to interpret the contents based on the HTTP response's header
# i.e. look at its Content-Type.
#
function(ans, header, .encoding = NA)
{
  headerText = if(is.character(header)) header else header$value()
  http.header = parseHTTPHeader(headerText)

  stop.if.HTTP.error(http.header)  

  content.type = getContentType(http.header)
  if(!isBinaryContent(, content.type)) {
     ans = rawToChar(ans)
     if(length(.encoding)  == 0 || is.na(.encoding)) {
        charset = grep("charset", content.type, value = TRUE)
        if(length(charset))
          .encoding = strsplit(charset, "=")[[1]][2]
     }
     if(length(.encoding) && !is.na(.encoding))
       Encoding(ans) = .encoding
  } else {
     attr(ans, "Content-Type") = getContentType(http.header)
     ans
  }
  ans
}

trim =
function(x) 
{
    gsub("(^[[:space:]]+|[[:space:]]+$)", "", x, perl = TRUE)
}

getContentType = 
function(header, full = FALSE)
{
   i = match("content-type", tolower(names(header)))
   if( is.na( i ) )
      return(character())

   tmp = trim(strsplit(header[i[1]], "; *")[[1]])
   if(!full)
       return(tmp)

   vals = strsplit(tmp, "=")
   structure(gsub(";$", "", sapply(vals, function(x) x[length(x)])), 
             names = sapply(vals, function(x) if(length(x) > 1) x[1] else ""))
}

textContentTypes = c("html", "text", "xhtml", "plain", "xml", "x-latex", "css", "latex", "sgml", "postscript", "texinfo")

isBinaryContent =
function(header, type = getContentType(header)[1],
          textTypes = getOption("text.content.types"))
{
   if(is.null(textTypes))
     textTypes = textContentTypes
   type.els = strsplit(type, "/")[[1]]
   if(any(type.els %in% textContentTypes))
      return(FALSE)

   TRUE
}

