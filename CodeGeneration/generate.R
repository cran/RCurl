library(RGCCTranslationUnit)
#library(RAutoGenRunTime)   # for bitlist.

tu = parseTU("enum.c.t00.tu")
edefs = lapply(getEnumerations(tu), resolveType, tu)

curl.h = "/usr/local/include/curl/curl.h"
curl.h = "~/Downloads/curl-7.19.4/include/curl/curl.h"

cpp = getCppDefines(curl.h)
defs = RGCCTranslationUnit:::processDefines(cpp, tu = tu, filter = NULL)
i = defs$macros %in% names(edefs$CURLoption@values)

##############



writeEnumGenerationRCode(edefs[["CURLoption"]]@values, "../inst/enums/Renums.c", includes = '<curl/curl.h>')


ifdef = 
c("KEYPASSWD", "DIRLISTONLY", "APPEND", "KRBLEVEL", "USE_SSL", 
"TIMEOUT_MS", "CONNECTTIMEOUT_MS", "HTTP_TRANSFER_DECODING", 
"HTTP_CONTENT_DECODING", "NEW_FILE_PERMS", "NEW_DIRECTORY_PERMS", 
"POSTREDIR", "OPENSOCKETFUNCTION", 
"OPENSOCKETDATA", "COPYPOSTFIELDS", "PROXY_TRANSFER_MODE", "SEEKFUNCTION", 
"SEEKDATA", "CRLFILE", "ISSUERCERT", "ADDRESS_SCOPE", "CERTINFO", 
"USERNAME", "PASSWORD", "PROXYUSERNAME", "PROXYPASSWORD",
"SSH_HOST_PUBLIC_KEY_MD5", "NOPROXY", "TFTP_BLKSIZE", 
"SOCKS5_GSSAPI_SERVICE", "SOCKS5_GSSAPI_NEC", 
"PROTOCOLS", "REDIR_PROTOCOLS")

sprintf("RCURL_CHECK_ENUM(CURLOPT_%s)\n", ifdef)

txt = readLines(curl.h)
txt = readLines(curl.h)
cinit = grep("^[[:space:]]*CINIT\\(", txt, val = TRUE)
names(cinit) = gsub(".*CINIT\\(([A-Z0-9_]+),.*", "\\1", cinit)

cinit[ifdef] = sprintf("#ifdef HAVE_CURLOPT_%s\n%s\n#endif\n", ifdef, cinit[ifdef])


cat(cinit,   # grep("CINIT\\(", cinit, val = TRUE)
      sprintf("#ifdef %s\n{ \"%s\", %s}%s\n#endif\n", 
                 names(defs$macros[i]),
                 gsub("^CURLOPT_", "", names(defs$macros[i])),
                 defs$macros[i],
                 c(rep(",", length(defs$macros[i]) - 1), "")),
         sep = "\n", file = "../src/CURLOptTable.h")


vals = edefs$CURLINFO@values
vals = vals[ - match(c("CURLINFO_NONE", "CURLINFO_LASTONE"), names(vals))]
cat(paste("CURLINFO(", gsub("CURLINFO_", "", names(vals)), ")", "\n", collapse = ",\n"),
     file = "../src/CURLINFOTable.h")


con = file("../R/curlEnums.R", "w")
cat("if(!is.null(getClassDef('EnumValue'))) {\n", file = con)
enumNames = c("curl_infotype", "CURLcode", "curl_proxytype", "curl_usessl",
              "curl_ftpccc", "curl_ftpauth", "curl_ftpcreatedir", "curl_ftpmethod",
              "CURL_NETRC_OPTION", 
              "CURLFORMcode",
              "curl_TimeCond",
             "curl_closepolicy",
            )

if(any(!(enumNames %in% names(edefs))))
  stop("can't match ", paste(enumNames[!(enumNames %in% names(edefs))] , collapse = ", "))
# Ignored for now: CURLformoption

# anonymous  CURL_HTTP_VERSION, CURL_SSLVERSION

sapply(edefs[enumNames], writeCode, "r", file = con)


sapply(edefs[c("6368", "6604")], 
           function(x) 
            cat(paste(gsub("CURL_", "", names(x@values)), " = ", x@values, "L", sep = "", collapse = "\n"), "\n\n", file = con))


cat("\n}\n", file = con)
close(con)


 # Generate the documentation for the coercion methods.
sprintf("\\alias{%s-class}", enumNames)
cat(paste(sapply(c("integer", "numeric", "character"), function(x)  sprintf("\\alias{coerce,%s,%s-method}", x, enumNames)), collapse = "\n"))






 # CURLPROTO
