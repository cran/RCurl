promptPassword =
function(prompt, len)
{
 cat(prompt, ": (max of ", len, " characters)> ", sep="")
 scan(what = "", nmax = 1)
}

x = getURL("https://my.ucdavis.edu", userpwd = "",
                                     header = TRUE, verbose = TRUE,
                                     cookiefile = "/home/duncan/Rcookies",
                                     netrc = TRUE,
                                     maxredirs = as.integer(20),
  #netrc.file = "/home2/duncan/.netrc1",
                                     followlocation = TRUE) # , passwdfunction = promptPassword)
print(x)


