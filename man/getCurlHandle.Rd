\name{getCurlHandle}
\alias{getCurlHandle}
\alias{getCurlMultiHandle}
\alias{dupCurlHandle}
\title{Create libcurl handles}
\description{
  These functions create and duplicate curl handles
  for use in calls to the HTTP facilities provided by
  that low-level language and this R-level interface.
  A curl handle is an opaque data type that contains a
  reference to the internal C-level data structure
  of libcurl for performing HTTP requests.

  The \code{getCurlMutliHandle} returns an object
  that can be used for concurrent, multiple requests.
  It is quite different from the regular curl handle
  and again, should be treated as an opaque data type.
}
\usage{
getCurlHandle(..., .opts = NULL, .encoding = integer())
dupCurlHandle(curl, ..., .opts = NULL, .encoding = integer())
getCurlMultiHandle()
}
\arguments{
  \item{curl}{the existing curl handle that is to be duplicated}
  \item{...}{a named list of curl options to set after the handle has
    been created.}
  \item{.opts}{a named list or \code{CURLOptions} object identifying the
    curl options for the handle. These and the \code{...} arguments are
    used after the handle has been created.}
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
  }  
}
\details{
  These functions create C-level data structures.
}
\value{
  An object of class \code{CURLHandle}
  which is simply a pointer to the memory for the C
  structure.
}
\references{Curl homepage \url{http://curl.haxx.se}}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
  \code{\link{getURL}}
  \code{\link{curlPerform}}
}
\examples{

}
\keyword{IO}


