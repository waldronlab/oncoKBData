% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/oncoKB.R
\name{curatedGenes}
\alias{curatedGenes}
\title{Get a table of curated oncogenes}
\usage{
curatedGenes(api, includeEvidence = TRUE)
}
\arguments{
\item{api}{An OncoKB API instance as returned by \code{oncoKB()}}

\item{includeEvidence}{\code{logical(1)} Whether to include additional data in the
\code{summary} and \code{background} columns (default: \code{TRUE})}
}
\value{
A tibble of curated oncogenes
}
\description{
Get a table of curated oncogenes
}
\examples{

oncokb <- oncoKB()
curatedGenes(oncokb)

}
