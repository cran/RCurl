\name{getURL}
\alias{getURL}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Download URL}
\description{

  The request supports any of the facilities within the
  version of libcurl that was installed.
  One can examine these via \code{\link{curlVersion}}.
}
\usage{
getURL(url, ..., write = basicTextGatherer(), curl = getCurlHandle())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{url}{a string giving the URI}
  \item{\dots}{named values that are interpreted as CURL options
    governing the HTTP request.}
  \item{write}{if explicitly supplied, this is a function that is called
    with a single argument each time the the HTTP response handler has
    gathered sufficient text. The argument to the function is
    a single string.  The default argument provides
    both a  function for cumulating this text and is then used
    to retrieve it as the return value for this function.
  }
  \item{curl}{the previously initialized CURL context/handle which can
    be used for multiple requests.}
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
  if("ssl" \%in\% names(curlVersion()$features))
      getURL("https://sourceforge.net/")


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

  x = getURL("http://www.nytimes.com",
                 header = TRUE, verbose = TRUE,
                 cookiefile = "/home/duncan/Rcookies",
                 netrc = TRUE,
                 maxredirs = as.integer(20),
                 netrc.file = "/home2/duncan/.netrc1",
                 followlocation = TRUE)


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

}
\keyword{IO}
\concept{Web}
\concept{HTTP}
