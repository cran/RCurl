\name{curlPerform}
\alias{curlPerform}
\title{Perform the HTTP query}
\description{
  This function causes the HTTP query, that has been specified
  via the different options, to be sent and processed.
  Unlike in curl itself, one can specify all the options
  in this call as an atomic invocation.
  This avoids having to set the options and then perform
  the action. Instead, this is all done in one call.
}
\usage{
curlPerform(..., .opts = list(), curl = getCurlHandle())
}
\arguments{
  \item{curl}{the \code{CURLHandle} object giving the structure for the
    options  and that will process the command.}
  \item{...}{a named list of curl options to set after the handle has
    been created.}
  \item{.opts}{a named list or \code{CURLOptions} object identifying the
    curl options for the handle.}    
}
\details{
}
\value{
  A integer value indicating the status of the request.
  This should be 0 as other errors will generate
  errors.
}
\references{Curl homepage \url{http://curl.haxx.se}}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
 \code{\link{getURL}}
 \code{\link{postForm}}
 \code{\link{getForm}}
 \code{\link{curlSetOpt}}
}
\examples{
  h = basicTextGatherer()
  curlPerform(url="http://www.omegahat.org/RCurl", writefunction = h$update)
   # Now read the text that was cumulated during the query response.
  h$value()


  # SOAP request
body = '<?xml version="1.0" encoding="UTF-8"?>\
<SOAP-ENV:Envelope SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" \
                   xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" \
                   xmlns:xsd="http://www.w3.org/1999/XMLSchema" \
                   xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" \
                   xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance">\
  <SOAP-ENV:Body>\
       <namesp1:hi xmlns:namesp1="http://www.soaplite.com/Demo"/>\
  </SOAP-ENV:Body>\
</SOAP-ENV:Envelope>\n'


  h$reset()
curlPerform(url="http://services.soaplite.com/hibye.cgi",
            httpheader=c(Accept="text/xml", Accept="multipart/*", SOAPAction='"http://www.soaplite.com/Demo#hi"',
                         'Content-Type' = "text/xml; charset=utf-8"),
            postfields=body,
            writefunction = h$update,
            verbose = TRUE
            )

  body = h$value()


}
\keyword{IO}


