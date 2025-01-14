% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bCond.tree.conversion.R
\name{treeCKT2matrixCKT}
\alias{treeCKT2matrixCKT}
\title{Construction of the matrix of estimated CKT given an estimated CKT tree}
\usage{
treeCKT2matrixCKT(estimatedTree, newDataXI = NULL, newDataXJ = NULL)
}
\arguments{
\item{estimatedTree}{the tree that has been estimated before,
for example by \code{\link{bCond.treeCKT}}}

\item{newDataXI}{this is a matrix of size \eqn{n' \times |I|}
where \eqn{|I|} is the number of conditioned variables.}

\item{newDataXJ}{this is a matrix of size \eqn{n' \times |J|}
where \eqn{|J|} is the number of conditional variables.

By default both \code{newDataXI} and \code{newDataXJ} are \code{NULL}
meaning that we return the matrix of conditional Kendall's tau for the original data
used to compute the \code{estimatedTree}}
}
\value{
a matrix of size \eqn{|I|(|I|-1) \times m} where each component corresponds
to a conditional Kendall's tau between a pair of conditional variables
conditionally to the conditioned variables in one of the boxes
}
\description{
Construction of the matrix of estimated CKT given an estimated CKT tree
}
