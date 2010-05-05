
r = RCurl:::dynCurlReader()
debug(r$update)
o = fun(search_value = "dog", writefunction = r$update)


postForm("http://www.itis.gov/servlet/SingleRpt/SingleRpt", search_topic = "all", search_kingdom = "every", 
         search_span = "containing", search_value = "dog", 
         categories = "All", source = "html", search_credRating = "All",
         style = 'post')



f = function()
{
require(XML)
require(RCurl)

w <- postForm("http://www.itis.gov/servlet/SingleRpt/SingleRpt",
        search_topic = "Scientific_Name",
        search_kingdom = "every",
        search_span = "containing",
        search_value = "elapidae",
        search_credRating = "All",
        categories = "TaxHier",
        source = "html",
        Go = "Search",
        style = 'POST')
  return(w)
} 
