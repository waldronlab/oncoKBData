# setwd("~/gh/oncoKB")
file_loc <- "inst/service/oncoKB/api.json"

download.file(
    url = "https://www.oncokb.org/api/v1/v2/api-docs?group=Public%20APIs",
    destfile = file_loc
)

md5 <- digest::digest(file_loc, file = TRUE)
kblines <- readLines("R/oncoKB.R")
mdline <- grep("\"[0-9a-f]{32}\"", kblines, value = TRUE)
oldmd5 <- unlist(strsplit(mdline, "\""))[[2]]
updatedlines <- gsub("\"[0-9a-f]{32}\"", dQuote(md5, FALSE), kblines)

## success -- updated API files and MD5
if (!identical(oldmd5, md5)) {
    writeLines(updatedlines, con = file("R/oncoKB.R"))
    quit(status = 0)
} else {
## failure -- API the same
    quit(status = 1)
}
