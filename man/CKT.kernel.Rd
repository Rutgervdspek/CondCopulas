% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimationCKT.kernel.R
\name{CKT.kernel}
\alias{CKT.kernel}
\title{Estimation of conditional Kendall's tau using kernel smoothing}
\usage{
CKT.kernel(
  observedX1,
  observedX2,
  observedZ,
  newZ,
  h,
  kernel.name = "Epa",
  methodCV = "Kfolds",
  Kfolds = 5,
  nPairs = 10 * length(observedX1),
  typeEstCKT = 4,
  progressBar = TRUE
)
}
\arguments{
\item{observedX1}{a vector of n observations of the first variable}

\item{observedX2}{a vector of n observations of the second variable}

\item{observedZ}{a vector of n observations of the conditioning variable,
or a matrix with n rows of observations of the conditioning vector}

\item{newZ}{the new data of observations of Z at which
the conditional Kendall's tau should be estimated.}

\item{h}{the bandwidth used for kernel smoothing.
If this is a vector, then cross-validation is used following the method
given by argument \code{methodCV} to choose the best bandwidth
before doing the estimation.}

\item{kernel.name}{name of the kernel used for smoothing.
Possible choices are "Gaussian" (Gaussian kernel) and "Epa" (Epanechnikov kernel).}

\item{methodCV}{method used for the cross-validation.
Possible choices are \code{leave-one-out} and \code{Kfolds}.}

\item{Kfolds}{number of subsamples used,
if \code{methodCV = "Kfolds"}.}

\item{nPairs}{number of pairs used in the cross-validation criteria,
if \code{methodCV = "leave-one-out"}.}

\item{typeEstCKT}{type of estimation of the conditional Kendall's tau.
Default is 4. 1 and 3 produced biased estimator while 2 does not attain the full range
[-1,1].}

\item{progressBar}{if TRUE, a progressbar for each h is displayed
to show the progress of the computation.}
}
\description{
Estimation of conditional Kendall's tau using kernel smoothing
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
estimatedCKT_kernel <- CKT.kernel(
   observedX1 = X1, observedX2 = X2, observedZ = Z,
   newZ = newZ, h = 0.07, kernel.name = "Epa")$estCKT

# Comparison between true Kendall's tau (in black)
# and estimated Kendall's tau (in red)
trueConditionalTau = -0.9 + 1.8 * pnorm(newZ, mean = 5, sd = 2)
plot(newZ, trueConditionalTau , col="black",
   type = "l", ylim = c(-1, 1))
lines(newZ, estimatedCKT_kernel, col = "red")

}
\references{
Derumigny, A., & Fermanian, J. D. (2019).
On kernel-based estimation of conditional Kendall’s tau:
finite-distance bounds and asymptotic behavior.
Dependence Modeling, 7(1), 292-321.
}
\seealso{
\code{\link{CKT.estimate}} for other estimators of conditional Kendall's tau.
\code{\link{CKTmatrix.kernel}} for a generalization of this function
when the conditioned vector is of dimension \code{d} instead of dimension \code{2} here.
}
