\name{curlSetOpt}
\alias{curlSetOpt}
\title{Set values for the CURL options}
\description{
  This function allows us to set values for the
  possible options in the CURL data structure
  that defines the HTTP request.
  These options persist across calls in the
  \code{CURLHandle} object.
}
\usage{
curlSetOpt(..., .opts = list(), curl = getCurlHandle())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{...}{a named list of curl options to set after the handle has
    been created.}
  \item{.opts}{a named list or \code{CURLOptions} object identifying the
    curl options for the handle.}  
  \item{curl}{the \code{CURLHandle} object created earlier via
   a call to \code{\link{getCurlHandle}} or \code{\link{dupCurlHandle}}}
}
\value{
  An integer value giving the status of the return.
  This should be 0 as if there was an error in the libcurl
  mechiansim,   we will throw it there.
}

\references{Curl homepage \url{http://curl.haxx.se}}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
  \code{\link{getCurlHandle}}
  \code{\link{dupCurlHandle}}  
}
\examples{

}
\keyword{IO}


