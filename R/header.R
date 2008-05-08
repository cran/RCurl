parseHTTPHeader =
  #
  # 
  # returns a named list of the fields. Allows duplicates.
  #
  #
  # This is taken from SSOAP. Need to remove the version there which
  # doesn't do the strsplit() if lines is a single string.
  #
function (lines) 
{
    if (length(lines) < 1) 
        return(NULL)

    if(length(lines) == 1)
      lines = strsplit(lines, "\r\n")[[1]]

    status = lines[1]
    lines = lines[-c(1, length(lines))]
    lines = gsub("\r\n", "", lines)
    if (FALSE) {
        header = lines[-1]
        header <- read.dcf(textConnection(header))
    }
    else {
        els <- sapply(lines, function(x) strsplit(x, ":[ ]*"))
        header <- lapply(els, function(x) x[2])
        names(header) <- sapply(els, function(x) x[1])
    }
    els <- strsplit(status, " ")[[1]]
    header[["status"]] <- as.integer(els[2])
    header[["statusMessage"]] <- els[3]
    header
}


getEncoding =
function(x) {
  val = gsub("Content-Type:.*;\\Wcharset=", "", x)
  if(nchar(val) == nchar(x)) # See if there was any substitution done, i.e. a match.
    return(NA)
  val = gsub("\\\r\\\n", "", val)

  switch(val, "UTF-8" =, "utf-8" = 1L, "ISO-8859-1" = 2L, -1L)
}

findHTTPHeaderEncoding =
function(str)
{
  els = strsplit(str, "\\r\\n")
  v = lapply(els, getEncoding)

  if(any(!is.na(v))) {
    v[[!is.na(v)]][[1]]
  } else
     -1L
}
