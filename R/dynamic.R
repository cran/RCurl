dynCurlReader = 
#
# Reads the header and then sets the appropriate writefunction
# to harvest the body of the HTTP response.
#
function(curl = getCurlHandle(), txt = character(), max = NA, value = NULL, verbose = FALSE,
          binary = NA, baseURL = NA) 
{
    header = character()    # for the header
    buf = NULL              # for a binary connection.
    content.type = character()

    curHeaderStatus = -1
    update = function(str) {

	if((length(header) == 0 || curHeaderStatus %in% c(-1, 100)) && (length(str) == 0 || length(grep("^[[:space:]]+$", str)))) {
              # Found the end of the header so wrapup the text and put it into the header variable
          oldHeader = header
	  header <<- c(txt, "")
          txt <<- character()
          http.header = parseHTTPHeader(c(header, str))

          if(http.header[["status"]] == 100) { # && length(http.header) == 2)
               curHeaderStatus <<- 100
                   # see if there are any attributes to keep other than status and statusMessage.
               val.ids = setdiff(names(http.header), c("status", "statusMessage"))

               if(length(val.ids))
                 header <<- http.header[val.ids]
               else
                 header <<- character()

               return(nchar(str, "bytes"))
          } else
             curHeaderStatus = http.header[["status"]]

          if(length(oldHeader)) {
              tmp = setdiff(names(oldHeader), names(header))
              if(length(tmp))
                 header[tmp] <<- oldHeader[tmp]
          }          

         
          content.type <<- getContentType(http.header, TRUE)

          if(is.na(binary))
            binary = isBinaryContent(, content.type) 
          

             # This happens when we get a "HTTP/1.1 100 Continue\r\n" and then
             # a blank line.  
          if(is.na(http.header["status"])) {
             header <<- character()
             return( nchar(str, "bytes") )
          }
          

	  if(verbose)
              cat("Setting option to read content-type", content.type[1], "character set", content.type["charset"], "\n")
	  if(length(content.type) == 0 || (is.na(binary) || binary)) {
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
                if(!is.null(buf)) {
                   ans = as(buf, "raw")
                   if(length(content.type))
                      attr(ans, "Content-Type") = content.type
                   return(ans)
                }
                 
                if (is.null(collapse)) 
                    return(txt)
                ans = paste(txt, collapse = collapse, ...)
                if(length(content.type))
                      attr(ans, "Content-Type") = content.type
                ans
             }
           else 
             function() {
               tmp = if(!is.null(buf))
                        as(buf, "raw") 
                      else
                        txt
               if(length(content.type))
                    attr(tmp, "Content-Type") = content.type               
               value(tmp)
             }


    ans = list(update = update, 
               value = val, 
               reset = reset, 
               header = function() header, 
               curl = function() curl)

    class(ans) <- c("DynamicRCurlTextHandler", "RCurlTextHandler", "RCurlCallbackFunction")
    ans$reset()
    ans  
}
