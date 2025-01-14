% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimationCKT.classif.GLM.R
\name{CKT.predict.GLM}
\alias{CKT.predict.GLM}
\title{Predict the values of conditional Kendall's tau by penalized GLM}
\usage{
CKT.predict.GLM(fit, newData)
}
\arguments{
\item{fit}{result of a call to CKT.fit.GLM}

\item{newData}{new matrix of observations, with the same number of variables.
and same names as the designMatrix that was used to fit the GLM.}
}
\value{
a vector of (predicted) conditional Kendall's taus of the same size
as the number of rows of the newData.
}
\description{
Predict the values of conditional Kendall's tau by penalized GLM
}
\examples{
# We simulate from a conditional copula
set.seed(1)
N = 800
Z = rnorm(n = N, mean = 5, sd = 2)
conditionalTau = 2*plogis(-1 + 0.8*Z - 0.1*Z^2) - 1
simCopula = VineCopula::BiCopSim(N=N , family = 1,
    par = VineCopula::BiCopTau2Par(1 , conditionalTau ))
X1 = qnorm(simCopula[,1])
X2 = qnorm(simCopula[,2])

datasetP = datasetPairs(X1 = X1, X2 = X2, Z = Z, h = 0.07, cut = 0.9)
designMatrix = cbind(datasetP[,2], datasetP[,2]^2)
fitCKT_GLM <- CKT.fit.GLM(
  datasetPairs = datasetP, designMatrix = designMatrix,
  maxiterOut = 10, maxiterIn = 5)

newZ = seq(2,10,by = 0.1)
estimatedCKT_GLM = CKT.predict.GLM(
  fit = fitCKT_GLM, newData = cbind(newZ, newZ^2))

# Comparison between true Kendall's tau (in red)
# and estimated Kendall's tau (in black)
trueConditionalTau = 2*plogis(-1 + 0.8*newZ - 0.1*newZ^2) - 1
plot(newZ, trueConditionalTau , col="red",
   type = "l", ylim = c(-1, 1))
lines(newZ, estimatedCKT_GLM)


}
\references{
Derumigny, A., & Fermanian, J. D. (2019).
A classification point-of-view about conditional Kendall’s tau.
Computational Statistics & Data Analysis, 135, 70-94.
(Algorithm 7)
}
