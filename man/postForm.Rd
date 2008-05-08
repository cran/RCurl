\name{postForm}
\alias{postForm}
\alias{getForm}
\title{Submit an HTML form}
\description{
  These functions provide facilities for submitting an HTML
  form using either the simple GET mechanism (appending the name-value
  pairs of parameters in the URL) or the POST method which puts
  the name-value pairs as separate sections  in the body of the 
  HTTP request. The choice of action is defined by the form,
  not the caller.
}
\usage{
postForm(uri, ..., .params = list(), .opts = curlOptions(url = uri),
         curl = getCurlHandle(), style = 'HTTPPOST')
getForm(uri, ..., .params = character(), .opts = list(), curl = getCurlHandle())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{uri}{the full URI to which the form is to be posted. This
    includes the host and the specific file or script which will process
    the form.}
  \item{\dots}{the name-value pairs of parameters.
    Note that these are not the CURL options.}
  \item{.params}{instead of specifying the name-value parameters in
    "free" form via the \dots argument, one can specify them
     as named list or character vector.
  }
  \item{.opts}{an object representing the CURL options for this call.}
  \item{curl}{the \code{CURLHandle} object created earlier if one is
    reusing these objects. Otherwise, a new one is generated and
    discarded.}
  \item{style}{this is typically a string
    and controls how the form data is posted, specifically
    the value for the Content-Type header and the particular
    representation.
    Use 'httppost' to use a \code{multipart/form-data}
    transmission
    and use 'post' for \code{application/x-www-form-urlencoded}
    content.
    This string is compared to the names
    of (the internal) \code{PostStyles} vector using partial
    matching.  In the future, we will use
    enum values within R.
    The default is \code{multipart/form-data} for reasons of backward compatability.
    }
}
\details{
  Creating a new \code{CURLHandle} allows the C-level code
  to more efficiently map the R-level values to their
  C equivalents needed to make the call. However, reusing
  the handle across calls can be more efficient in that
  the connection to a server can be maintained and thus,
  the sometimes expensive task of establishing it is
  avoided in subsequent calls.
}
\value{
  By default, the text from the HTTP response is
  returned.  
}


\seealso{
  \code{\link{getURL}}
  \code{\link{curlOptions}}
  \code{\link{curlSetOpt}}
}
\examples{

   # Two ways to submit a query to google. Searching for RCurl
  getURL("http://www.google.com/search?hl=en&lr=&ie=ISO-8859-1&q=RCurl&btnG=Search")

   # Here we let getForm do the hard work of combining the names and values.
  getForm("http://www.google.com/search", hl="en", lr="", ie="ISO-8859-1",  q="RCurl", btnG="Search")

   # And here if we already have the parameters as a list/vector.
  getForm("http://www.google.com/search", .params = c(hl="en", lr="", ie="ISO-8859-1",  q="RCurl", btnG="Search"))


   # Now looking at POST method for forms.
  postForm("http://www.speakeasy.org/~cgires/perl_form.cgi",
            "some_text" = "Duncan",
            "choice" = "Ho",
            "radbut" = "eep",
            "box" = "box1, box2"
          )

  # Genetic database via the Web.
 x = postForm('http://www.wormbase.org/db/searches/advanced/dumper',
         species="briggsae",
         list="",
         flank3="0",
         flank5="0",
         feature="Gene Models",
         dump = "Plain TEXT",
         orientation = "Relative to feature",
         relative = "Chromsome",
         DNA ="flanking sequences only",
         .cgifields = paste(c("feature", "orientation", "DNA", "dump","relative"), collapse=", "))


 # Note that we don't have to paste multiple values together ourselves,
 # e.g. the .cgifields can be specified as a character vector rather
 # than a string.
 x = postForm('http://www.wormbase.org/db/searches/advanced/dumper',
         species="briggsae",
         list="",
         flank3="0",
         flank5="0",
         feature="Gene Models",
         dump = "Plain TEXT",
         orientation = "Relative to feature",
         relative = "Chromsome",
         DNA ="flanking sequences only",
         .cgifields =c("feature", "orientation", "DNA", "dump", "relative"))

	  
}
\keyword{IO}


