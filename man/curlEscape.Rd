\name{curlEscape}
\alias{curlEscape}
\alias{curlUnescape}
\title{Handle characters in URL that need to be escaped}
\description{
  These functions convert between URLs that are
  human-readable and those that have special characters
  escaped.  For example, to send a URL with a space,
  we need to represent the space as \code{\%20}.
  
}
\usage{
curlEscape(urls)
curlUnescape(urls)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{urls}{ a character vector giving the strings to be escaped or unescaped.}
}
\details{
  This calls \code{curl_escape} or \code{curl_unescape} in the libcurl library.
}
\value{
  A character vector that has corresponding elements
  to the input with the characters escaped or not.
}
\references{Curl homepage \url{http://curl.haxx.se}}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\examples{
  curlEscape("http://www.abc.com?x=a is a sentence&a b=and another")

  # Reverse it should get back original
  curlUnescape(curlEscape("http://www.abc.com?x=a is a sentence&a b=and another"))
}
\keyword{IO}


