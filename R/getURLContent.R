getURLContent =
function(url, ..., curl = getCurlHandle(...), .encoding = NA)
{
  header = basicTextGatherer()
  ans = getBinaryURL(url, headerfunction = header$update, curl = curl)

  http.header = parseHTTPHeader(header$value())

  if( floor(as.integer(http.header[["status"]])/100) == 4) {
     klass =  RCurl:::getHTTPErrorClass(http.header[["status"]])
     err = simpleError(http.header[["statusMessage"]])
     class(err) = c(klass, class(err))
     #signalCondition(err)
     stop(err)
  }

  content.type = getContentType(http.header)
  if(!isBinaryContent(, content.type)) {
     ans = rawToChar(ans)
     if(is.na(.encoding)) {
        charset = grep("charset", content.type, value = TRUE)
        if(length(charset))
          .encoding = strsplit(charset, "=")[[1]][2]
     }
     if(!is.na(.encoding))
       Encoding(ans) = .encoding
  } else {
     attr(ans, "Content-Type") = getContentType(http.header)
     ans
  }
  ans
}

getContentType = 
function(header)
{
   if(! ("Content-Type" %in% names(header)) )
      return(character())

   strsplit(header["Content-Type"], "; * ")[[1]]
}

isBinaryContent =
function(header, type = getContentType(header)[1])
{
   type.els = strsplit(type, "/")[[1]]
   if(any(type.els %in% c("html", "text", "xhtml", "plain")))
      return(FALSE)

   TRUE
}

