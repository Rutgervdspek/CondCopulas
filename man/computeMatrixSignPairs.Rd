% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimationCKT.datasetPairs.R
\name{computeMatrixSignPairs}
\alias{computeMatrixSignPairs}
\title{Compute the matrix of signs of pairs}
\usage{
computeMatrixSignPairs(vectorX1, vectorX2, typeEstCKT)
}
\arguments{
\item{vectorX1}{vector of observed data (first coordinate)}

\item{vectorX2}{vector of observed data (second coordinate)}

\item{typeEstCKT}{if typeEstCKT = 2 or 4, compute the matrix whose term (i,j) is :
   \deqn{1 \{ (X_{i,1} - X_{j,1}) * (X_{i,2} - X_{j,2}) > 0 \}
 - 1 \{ (X_{i,1} - X_{j,1}) * (X_{i,2} - X_{j,2}) < 0 \},}
 where \eqn{1} is the indicator function.

For typeEstCKT = 1 (resp. typeEstCKT = 3)
a negatively biased (resp. positively) matrix is given.}
}
\value{
an \eqn{n * n} matrix with the signs of each pair
of observations.
}
\description{
Compute the matrix of signs of pairs
}
\keyword{internal}
