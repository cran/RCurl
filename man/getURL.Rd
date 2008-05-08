\name{getURL}
\alias{getURL}
\alias{getURI}
\title{Download a URI}
\description{
  This function downloads one or more URIs (a.k.a. URLs).
  It uses libcurl under the hood to perform the request
  and retrieve the response.
  There are a myriad of options that can be specified using
  the \dots mechanism to control the creation and submission
  of the request and the processing of the response.
  
  The request supports any of the facilities within the
  version of libcurl that was installed.
  One can examine these via \code{\link{curlVersion}}.
}
\usage{
getURL(url, ..., .opts = list(), write = basicTextGatherer(),
         curl = getCurlHandle(), async = length(url) > 1, .encoding = integer())
getURI(url, ..., .opts = list(), write = basicTextGatherer(),
         curl = getCurlHandle(), async = length(url) > 1, .encoding = integer())
}
\arguments{
  \item{url}{a string giving the URI}
  \item{\dots}{named values that are interpreted as CURL options
    governing the HTTP request.}
  \item{.opts}{a named list or \code{CURLOptions} object identifying the
    curl options for the handle. This is merged with the values of \dots
    to create the actual options for the curl handle in the request.}  
  \item{write}{if explicitly supplied, this is a function that is called
    with a single argument each time the the HTTP response handler has
    gathered sufficient text. The argument to the function is
    a single string.  The default argument provides
    both a  function for cumulating this text and is then used
    to retrieve it as the return value for this function.
  }
  \item{curl}{the previously initialized CURL context/handle which can
    be used for multiple requests.}
  \item{async}{a logical value that determines whether the download
    request should be done via asynchronous,concurrent downloading or a serial
    download. This really only arises when we are trying to download
    multiple URIs in a single call. There are trade-offs between
    concurrent and serial downloads, essentially trading CPU cycles
    for shorter elapsed times. Concurrent downloads reduce the overall
    time waiting for \code{getURI}/\code{getURL} to return.
  }
  \item{.encoding}{an integer or a string that explicitly identifies the
    encoding of the content that is returned by the HTTP server in its
    response to our query. The possible strings are
    \sQuote{UTF-8} or \sQuote{ISO-8859-1}
    and the integers should be specified symbolically
    as  \code{CE_UTF8} and \code{CE_LATIN1}.
    Note that, by default, the package attempts to process the header of
    the HTTP response to determine the encoding. This argument is used
    when such information is erroneous and the caller knows the correct
    encoding.
    The default value leaves the decision  to this default mechanism.
    This does however currently involve processing each line/chunk
    of the header (with a call to an R function). As a result,
    if one knows the encoding for the resulting response,
    specifying this avoids this slight overhead which is probably
    quite small relative to network latency and speed.
  }  
}
\details{

}
\value{
  If no value is supplied for \code{write},
  the result is the text that is the HTTP response.
  (HTTP header information is included if the header option for CURL is
  set to \code{TRUE} and no handler for headerfunction is supplied in
  the CURL options.)

  Alternatively, if a value is supplied for the \code{write} parameter,
  this is returned. This allows the caller to create a handler within
  the call and get it back. This avoids having to explicitly create
  and assign it and then call \code{getURL} and then access the result.
  Instead, the 3 steps can be inlined in a single call.
}
\references{Curl homepage \url{http://curl.haxx.se}}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
  \code{\link{curlPerform}}
  \code{\link{curlOptions}}
}
\examples{

   # Regular HTTP
  txt = getURL("http://www.omegahat.org/RCurl/")
   # Then we could parse the result.
  if(require(XML))
     htmlTreeParse(txt, asText = TRUE)


        # HTTPS. First check to see that we have support compiled into
        # libcurl for ssl.
  if("ssl" \%in\% names(curlVersion()$features)) {
     txt = tryCatch(getURL("https://sourceforge.net/"),
                    error = function(e) {
                                  getURL("https://sourceforge.net/",
                                            ssl.verifypeer = FALSE)
                              })

  }


     # Create a CURL handle that we will reuse.
  curl = getCurlHandle()
  pages = list()
  for(u in c("http://www.omegahat.org/RCurl/index.html",
             "http://www.omegahat.org/RGtk/index.html")) {
     pages[[u]] = getURL(u, curl = curl)
  }


    # Set additional fields in the header of the HTTP request.
    # verbose option allows us to see that they were included.
  getURL("http://www.omegahat.org", httpheader=c(Accept = "text/html", MyField="Duncan"), verbose = TRUE)



    # Arrange to read the header of the response from the HTTP server as
    # a separate "stream". Then we can break it into name-value
    # pairs. (The first line is the 
  h = basicTextGatherer()
  txt = getURL("http://www.omegahat.org/RCurl", header= TRUE, headerfunction = h[[1]], httpheader = c(Accept="text/html", Test=1), verbose = TRUE)
  read.dcf(textConnection(paste(h$value(NULL)[-1], collapse="")))



   # Test the passwords.
  x = getURL("http://www.omegahat.org/RCurl/testPassword/index.html",
               userpwd = "bob:duncantl")

\dontrun{
  #  Needs specific information from the cookie file on a per user basis
  #  with a registration to the NY times.
  x = getURL("http://www.nytimes.com",
                 header = TRUE, verbose = TRUE,
                 cookiefile = "/home/duncan/Rcookies",
                 netrc = TRUE,
                 maxredirs = as.integer(20),
                 netrc.file = "/home2/duncan/.netrc1",
                 followlocation = TRUE)
}

   d = debugGatherer()
   x = getURL("http://www.omegahat.org", debugfunction=d$update, verbose = TRUE)
   d$value()


    #############################################
    #  Using an option set in R
   opts = curlOptions(header = TRUE, userpwd = "bob:duncantl", netrc = TRUE)
   getURL("http://www.omegahat.org/RCurl/testPassword/index.html", verbose = TRUE, .opts = opts)

     # Using options in the CURL handle.
   h = getCurlHandle(header = TRUE, userpwd = "bob:duncantl", netrc = TRUE)
   getURL("http://www.omegahat.org/RCurl/testPassword/index.html",  verbose = TRUE, curl = h)



   # Use a C routine as the reader. Currently gives a warning.
  routine = getNativeSymbolInfo("R_internalWriteTest", PACKAGE = "RCurl")$address
  getURL("http://www.omegahat.org/RCurl/index.html", writefunction = routine)



  # Example
  uris = c("http://www.omegahat.org/RCurl/index.html", "http://www.omegahat.org/RCurl/philosophy.xml")
  txt = getURI(uris)
  names(txt)
  nchar(txt)

  txt = getURI(uris, async = FALSE)
  names(txt)
  nchar(txt)


  routine = getNativeSymbolInfo("R_internalWriteTest", PACKAGE = "RCurl")$address
  txt = getURI(uris, write = routine, async = FALSE)
  names(txt)
  nchar(txt)
   
}
\keyword{IO}
\concept{Web}
\concept{HTTP}
