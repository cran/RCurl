\name{getCurlHandle}
\alias{getCurlHandle}
\alias{dupCurlHandle}
\title{Create libcurl handles}
\description{
  These functions create and duplicate curl handles
  for use in calls to the HTTP facilities provided by
  that low-level language and this R-level interface.
}
\usage{
getCurlHandle(..., .opts = NULL)
dupCurlHandle(curl, ..., .opts = NULL)
}
\arguments{
  \item{curl}{the existing curl handle that is to be duplicated}
  \item{...}{a named list of curl options to set after the handle has
    been created.}
  \item{.opts}{a named list or \code{CURLOptions} object identifying the
    curl options for the handle. These and the \code{...} arguments are
    used after the handle has been created.}
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


