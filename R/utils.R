.bind_content <- function(x) {
    dplyr::bind_rows(
        httr::content(x)
    )
}

.invoke_fun <- function(api, name, ...) {
    do.call(`$`, list(api, name))(...)
}
