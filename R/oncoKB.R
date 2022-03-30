utils::globalVariables(c("clinicalAttributeId", "value", "sampleId"))

.handle_token <- function(token) {
    if (file.exists(token))
        token <- readLines(token)
    else if (grepl(.Platform$file.sep, token, fixed = TRUE))
        stop("The token filepath is not valid")
    token <- gsub("token: ", "", token)
    c(Authorization = paste("Bearer", token))
}

#' @rdname oncoKB
#'
#' @aliases oncoKB
#'
#' @title The R interface to the oncoKB API Data Service
#'
#' @description This section of the documentation lists the functions that
#'     allow users to access the oncoKB API. The main representation of the
#'     API can be obtained from the `oncoKB` function. The supporting
#'     functions listed here give access to specific parts of the API and
#'     allow the user to explore the API with individual calls.
#'
#' @param hostname character(1) The internet location of the service
#'     (default: 'www.cbioportal.org')
#'
#' @param protocol character(1) The internet protocol used to access the
#'     hostname (default: 'https')
#'
#' @param api. character(1) The directory location of the API protocol within
#'     the hostname (default: '/api/api-docs')
#'
#' @param token character(1) The Authorization Bearer token e.g.,
#'     "63eba81c-2591-4e15-9d1c-fb6e8e51e35d" or a path to text file.
#'
#' @return
#'
#'     oncoKB: An API object of class 'oncoKB'
#'
#' @importFrom AnVIL Service
#'
#' @examples
#' oncokb <- oncoKB()
#'
#' searchOps(api = cbio, keyword = "molecular")
#'
#' @export
oncoKB <- function(
    hostname = "www.oncokb.org",
    protocol = "https",
    api. = "/api/api-docs",
    token = character()
) {
    if (length(token))
        token <- .handle_token(token)

    apiUrl <- paste0(protocol, "://", hostname, api.)
    .oncoKB(
        Service(
            service = "oncoKB",
            host = hostname,
            config = httr::config(
                ssl_verifypeer = 0L, ssl_verifyhost = 0L, http_version = 0L
            ),
            authenticate = FALSE,
            api_reference_url = apiUrl,
            api_reference_md5sum = "e961ccb66b7fcc55bee3b211c646fcf1",
            api_reference_headers = token,
            package = "oncoKB",
            schemes = protocol
        ),
        api_header = token
    )
}
