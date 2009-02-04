ftpUpload =
  #
  # what is the name of the file or the contents of the file
  #
function(what, to, asText = inherits(what, "AsIs") || is.raw(what),
          ..., curl = getCurlHandle())
{
  curlPerform(url = to, upload = TRUE,
              readfunction = uploadFunctionHandler(what, asText), ..., curl = curl)
}

uploadFunctionHandler =
  #
  # returns the function that is called as the READFUNCTION callback.
  #
  # This handles raw, character and file contents.
  #
function(file, asText = inherits(file, "AsIs") || is.raw(file))
{
  if(!asText && !inherits(file, "connection"))
    file = file(file, "rb")

  if(asText) {
      pos = 1
      isRaw = is.raw(file)
      len = if(isRaw) length(file) else nchar(file)

      function(size) {

        if(pos > len)
          return(if(isRaw) raw(0) else character(0))

        ans = if(isRaw)
                  file[seq(pos, length = size)]
               else
                  substring(file, pos, pos + size)
        pos <<- pos + len
        ans
      }

   } else

      function(size) {
         readBin(file, raw(), size)
      }
}
