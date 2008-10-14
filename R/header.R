parseHTTPHeader =
  #
  # 
  #
  # Reads the lines from the HTTP response 
  # header and converts them into a
  # name=value  collection as a character vector.
  #
  # returns a named list of the fields. Allows duplicates.
function(lines)
{
 if(length(lines) < 1)
   return(NULL)

 if(length(lines) == 1)
    lines = strsplit(lines, "\r\n")[[1]]
 
 status = lines[1]

   # Get the status and if it is 100, then throw away the first 2 lines
   #  e.g. HTTP/1.1 100 Continue
   #       \r\n
 st = getStatus(status)
 if(st[["status"]] == 100) {
     # Have to worry about whether we just get a 100 and nothing else
     # and so lines[3] won't exist.
   status = lines[3]
   lines = lines[-(1:2)]
 }
 
 lines = lines[-c(1, length(lines))]
 lines = gsub("\r\n$","", lines)  # was \r\n\0$

 if(FALSE) { # Doesn't behave. Duplicates!
   header = lines[-1]
   header <- read.dcf(textConnection(header))
 } else {
   els <- sapply(lines, function(x) strsplit(x, ": *"))
   header <- sapply(els, function(x) x[2]) #XX what if more than 2 els.
   names(header) <- sapply(els, function(x) x[1]) 
 }

 st = getStatus(status)
 header[["status"]] = st[["status"]]
 header[["statusMessage"]] = st[["message"]] 
 
 header
}


getStatus =
  #
  # Reads the first line of the HTTP header, e.g of the form
  #   HTTP/1.1 200 OK
  # or
  #   HTTP/1.1 404 Not Found
  # and returns
  #   list(status = 404, message = "Not Found")
function(status)
{
 els <- strsplit(status, " ")[[1]] 
 list(status = as.integer(els[2]), message = paste(els[-c(1,2)], collapse = " "))
}




getEncoding =
function(x) {
  val = gsub("Content-Type:.*;\\W*charset=", "", x)
  if(all(nchar(val) == nchar(x))) # See if there was any substitution done, i.e. a match.
    return(NA)


  switch(val, "UTF-8" =, "utf-8" = 1L, "ISO-8859-1" = 2L, -1L)
}

findHTTPHeaderEncoding =
function(str)
{
  els = strsplit(str, "\\\r\\\n")
  v = lapply(els, getEncoding)

  if(any(!is.na(v))) {
    v[[!is.na(v)]][[1]]
  } else
     -1L
}
