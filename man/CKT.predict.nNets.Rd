% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimationCKT.classif.nNet.R
\name{CKT.predict.nNets}
\alias{CKT.predict.nNets}
\title{Predict the values of conditional Kendall's tau
using Model Averaging of Neural Networks}
\usage{
CKT.predict.nNets(fit, newData, aggregationMethod = "mean")
}
\arguments{
\item{fit}{result of a call to CKT.fit.nNet}

\item{newData}{new matrix of observations, with the same number of variables.
and same names as the designMatrix that was used to fit the Neural Networks.}

\item{aggregationMethod}{the method to be used to aggregate all the predictions
together. Can be \code{mean} or \code{median}.}
}
\value{
a vector of (predicted) conditional Kendall's taus of the same size
as the number of rows of the newData.
}
\description{
Predict the values of conditional Kendall's tau
using Model Averaging of Neural Networks
}
\examples{
# We simulate from a conditional copula
set.seed(1)
N = 800
Z = rnorm(n = N, mean = 5, sd = 2)
conditionalTau = -0.9 + 1.8 * pnorm(Z, mean = 5, sd = 2)
simCopula = VineCopula::BiCopSim(N=N , family = 1,
    par = VineCopula::BiCopTau2Par(1 , conditionalTau ))
X1 = qnorm(simCopula[,1])
X2 = qnorm(simCopula[,2])

newZ = seq(2,10,by = 0.1)
datasetP = datasetPairs(X1 = X1, X2 = X2, Z = Z, h = 0.07, cut = 0.9)
fitCKT_nNets <- CKT.fit.nNets(datasetPairs = datasetP)
estimatedCKT_nNets <- CKT.predict.nNets(
  fit = fitCKT_nNets, newData = matrix(newZ, ncol = 1))

# Comparison between true Kendall's tau (in black)
# and estimated Kendall's tau (in red)
trueConditionalTau = -0.9 + 1.8 * pnorm(newZ, mean = 5, sd = 2)
plot(newZ, trueConditionalTau , col="black",
   type = "l", ylim = c(-1, 1))
lines(newZ, estimatedCKT_nNets, col = "red")

}
\references{
Derumigny, A., & Fermanian, J. D. (2019).
A classification point-of-view about conditional Kendall’s tau.
Computational Statistics & Data Analysis, 135, 70-94.
(Algorithm 7)
}
