.DEMO_ENDPOINT <- "/api/v1/v2/api-docs?group=Public%20APIs"

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
#' @return oncoKB: An API object of class 'oncoKB'
#'
#' @importFrom AnVIL Service
#'
#' @examples
#' oncokb <- oncoKB()
#' \dontrun{
#' ## Authorization: Bearer token as a file
#' oncoKB(token = "~/onco_token.txt")
#' }
#' names(operations(oncokb))
#'
#' @export
oncoKB <- function(
    hostname = "www.oncokb.org",
    protocol = "https",
    api. = .DEMO_ENDPOINT,
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
            api_url = apiUrl,
            api_reference_url = apiUrl,
            api_reference_md5sum = "e05bf7beb434130f78c7836f8bda87df",
            api_reference_headers = token,
            package = "oncoKB",
            schemes = protocol
        ),
        api_header = token
    )
}

#' Get the Levels of Evidence Tables from OncoKB
#'
#' The levels of evidence table is an `S4Vectors` `DataFrame` that includes
#' metadata consisting of app, api, data, and oncoTree version tags which were
#' used to generate the table.
#'
#' @param api An OncoKB API instance as returned by `oncoKB()`
#'
#' @return A `DataFrame` with metadata
#'
#' @export
levelsOfEvidence <- function(api) {
    result <- httr::content(
        .invoke_fun(api, "infoGetUsingGET_1")
    )
    metadata <- result[!names(result) %in% "levels"]

    evid <- dplyr::bind_rows(result[["levels"]]) |>
        methods::as("DataFrame")

    S4Vectors::metadata(evid) <- metadata
    evid
}

#' Get a table of curated oncogenes
#'
#' @param includeEvidence `logical(1)` Whether to include additional data in the
#'   `summary` and `background` columns (default: `TRUE`)
#'
#' @inheritParams levelsOfEvidence
#'
#' @return A tibble of curated oncogenes
#'
#' @examples
#'
#' oncokb <- oncoKB()
#' curatedGenes(oncokb)
#'
#' @export
curatedGenes <- function(api, includeEvidence = TRUE) {
    .bind_content(
        .invoke_fun(
            api,
            "utilsAllCuratedGenesGetUsingGET_1",
            includeEvidence = includeEvidence
        )
    )
}

#' Obtain the OncoKB cancer gene list
#'
#' @inheritParams levelsOfEvidence
#'
#' @return A long tibble of genes with additional columns
#'
#' @examples
#'
#' oncokb <- oncoKB()
#' cancerGeneList(oncokb)
#'
#' @export
cancerGeneList <- function(api) {
    .bind_content(
        .invoke_fun(
            api,
            "utilsCancerGeneListGetUsingGET_1"
        )
    )
}
