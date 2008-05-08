library(RGCCTranslationUnit)
library(RAutoGenRunTime)   # for bitlist.

tu = parseTU.Perl("enum.c.t00.tu")
edefs = lapply(getEnumerations(tu), resolveType, tu)

writeEnumGenerationRCode(edefs[["CURLoption"]]@values, "../inst/enums/Renums.c", includes = '<curl/curl.h>')

