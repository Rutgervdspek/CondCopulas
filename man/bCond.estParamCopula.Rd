% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bCond.estimation.R
\name{bCond.estParamCopula}
\alias{bCond.estParamCopula}
\title{Estimation of the conditional parameters of a parametric conditional
copula with discrete conditioning events.}
\usage{
bCond.estParamCopula(U1, U2, family, partition)
}
\arguments{
\item{U1}{vector of \code{n} conditional pseudo-observations of the first conditioned variable}

\item{U2}{vector of \code{n} conditional pseudo-observations of the second conditioned variable}

\item{family}{the family of conditional copulas used.
Can be a number or a vector of size p}

\item{partition}{matrix of size \code{n * p},
where \code{p} is the number of conditioning events that are considered.
partition[i,j] should be the indicator of whether the \code{i}-th observation
belongs or not to the \code{j}-th conditioning event}
}
\value{
a list of size \code{p} containing the \code{p} conditional copulas
}
\description{
This function uses canonical maximum likelihood to estimate
}
\details{
This function is currently implemented only for one-parameter families
of conditional copulas and for the Student family with fixed degree of freedom.
}
\examples{
n = 800
Z = stats::runif(n = n)
CKT = 0.2 * as.numeric(Z <= 0.3) +
  0.5 * as.numeric(Z > 0.3 & Z <= 0.5) +
  - 0.8 * as.numeric(Z > 0.5)
simCopula = VineCopula::BiCopSim(N = n,
  par = VineCopula::BiCopTau2Par(CKT, family = 1), family = 1)
X1 = simCopula[,1]
X2 = simCopula[,2]
partition = cbind(Z <= 0.3, Z > 0.3 & Z <= 0.5, Z > 0.5)
condPseudoObs = bCond.pobs(X1 = X1, X2 = X2, partition = partition)

estimatedCondCopulas = bCond.estParamCopula(
  U1 = condPseudoObs[,1], U2 = condPseudoObs[,2],
  family = 1, partition = partition)
print(estimatedCondCopulas)
# Comparison with the true conditional parameters: 0.2, 0.5, -0.8.


}
\references{
Derumigny, A., & Fermanian, J. D. (2017).
About tests of the “simplifying” assumption for conditional copulas.
Dependence Modeling, 5(1), 154-197.
}
