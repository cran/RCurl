library(Rffi)

reg = CIF(voidType, list(sexpType, sexpType))


fin = function(obj)
         cat("Finalizer for", class(obj), "\n")

library(RCurl)
h = getCurlHandle()
callCIF(reg, "R_RegisterFinalizer", h@ref, fin, returnInputs = c(FALSE, FALSE))
rm(h)
gc()


x = new.env()
callCIF(reg, "R_RegisterFinalizer", x, fin, returnInputs = c(FALSE, FALSE))
rm(x)
gc()


