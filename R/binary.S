setClass("RCurlBinaryBuffer", representation(ref = "externalptr"))

binaryBuffer =
function(initialSize = 5000)
{
  a = .Call(R_curl_BinaryData_new, as.integer(initialSize))
  new("RCurlBinaryBuffer", ref = a)
}  


setAs("RCurlBinaryBuffer", "raw",
       function(from, to) {
         .Call(R_curl_BinaryData_to_raw, from@ref)
       })
