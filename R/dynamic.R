dynCurlReader = 
#
# Reads the header and then sets the appropriate writefunction
# to harvest the body of the HTTP response.
#
function(curl = getCurlHandle(), txt = character(), max = NA, value = NULL, verbose = FALSE) 
{
    header = character()    # for the header
    buf = NULL              # for a binary connection.
    update = function(str) {


	if(length(header) == 0 && (length(str) == 0 || length(grep("^[[:space:]]+$", str)))) {
	  header <<- c(txt, "")
          txt <<- character()
          http.header = parseHTTPHeader(c(header, str))

          if(http.header[["status"]] == 100) { # && length(http.header) == 2)
               header <<- character()
               return(nchar(str, "bytes"))
          }

          content.type = getContentType(http.header, TRUE)


             # This happens when we get a "HTTP/1.1 100 Continue\r\n" and then
             # a blank line.  
          if(is.na(http.header["status"])) {
             header <<- character()
             return( nchar(str, "bytes") )
          }
          

	  if(verbose)
              cat("Setting option to read content-type", content.type[1], "character set", content.type["charset"], "\n")
	  if(length(content.type) == 0 || isBinaryContent(, content.type)) {
             len = 5000
             buf <<- binaryBuffer(len)
             if(verbose) cat("Reading binary data:", content.type, "\n")
             curlSetOpt(writefunction = getNativeSymbolInfo("R_curl_write_binary_data")$address,
                        file = buf@ref, curl = curl)      
          } else {
             curlSetOpt(writefunction = update, .encoding = content.type["charset"], curl = curl)
          }
        } else {
          txt <<- c(txt, str)
          if (!is.na(max) && nchar(txt) >= max) 
              return(0)
        }
        nchar(str, "bytes")
    }

    reset = function() {
        txt <<- character()
    }
    val = if(missing(value))
             function(collapse = "", ...) {
                if(!is.null(buf))
                   return(as(buf, "raw"))
                 
                if (is.null(collapse)) 
                    return(txt)
                paste(txt, collapse = collapse, ...)
             }
           else 
             function() 
                 value(if(!is.null(buf)) as(buf, "raw") 
                       else txt)


    ans = list(update = update, 
               value = val, 
               reset = reset, 
               header = function() header, 
               curl = function() curl)

    class(ans) <- c("DynamicRCurlTextHandler", "RCurlTextHandler", "RCurlCallbackFunction")
    ans$reset()
    ans  
}
