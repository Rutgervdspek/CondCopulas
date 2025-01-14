

#' Estimation of conditional Kendall's taus by model averaging of Neural Networks
#'
#' @param datasetPairs the matrix of pairs and corresponding values of the kernel
#' as provided by \code{\link{datasetPairs}}.
#' @param designMatrix the matrix of predictor to be used for the fitting of the tree
#'
#' @param vecSize vector with the number of neurons for each network
#'
#' @param nObs_per_NN number of observations used for each neural network.
#'
#' @param verbose a number indicated what to print
#' \itemize{
#'     \item \code{0}: nothing printed at all.
#'     \item \code{1}: a message is printed at the convergence of each neural network.
#'     \item \code{2}: each optimization of each network is printed in detail.
#' }
#'
#' @return a list of the fitted neural networks
#'
#'
#' @references
#' Derumigny, A., & Fermanian, J. D. (2019).
#' A classification point-of-view about conditional Kendall’s tau.
#' Computational Statistics & Data Analysis, 135, 70-94.
#' (Algorithm 7)
#'
#' @examples
#' # We simulate from a conditional copula
#' set.seed(1)
#' N = 800
#' Z = rnorm(n = N, mean = 5, sd = 2)
#' conditionalTau = -0.9 + 1.8 * pnorm(Z, mean = 5, sd = 2)
#' simCopula = VineCopula::BiCopSim(N=N , family = 1,
#'     par = VineCopula::BiCopTau2Par(1 , conditionalTau ))
#' X1 = qnorm(simCopula[,1])
#' X2 = qnorm(simCopula[,2])
#'
#' newZ = seq(2,10,by = 0.1)
#' datasetP = datasetPairs(X1 = X1, X2 = X2, Z = Z, h = 0.07, cut = 0.9)
#' fitCKT_nets <- CKT.fit.nNets(datasetPairs = datasetP)
#'
#'
#' @export
#'
CKT.fit.nNets <- function(datasetPairs,
                          designMatrix = datasetPairs[,2:(ncol(datasetPairs)-3),drop=FALSE],
                          vecSize = rep(3, times = 10),
                          nObs_per_NN = 0.9*nrow(designMatrix),
                          verbose = 1)
{
  # Initialization
  length_list_nnet = length(vecSize)
  n = nrow(designMatrix)

  list_nnet = as.list(seq(length_list_nnet))

  for (i in 1:length_list_nnet)
  {
    # We choose at random the initial sample
    sampleId = sample.int(n = n, size = nObs_per_NN)

    # We compute the data matrix from this sample
    whichPairs = which( (datasetPairs[,"iUsed"] %in% sampleId)
                        & (datasetPairs[,"jUsed"] %in% sampleId) )
    datasetPairs_sample = datasetPairs[whichPairs,]

    designMatrix_sample = cbind(designMatrix[whichPairs,])

    fit_nnet = nnet::nnet(as.factor(datasetPairs_sample[ ,1]) ~ .,
                          data = designMatrix_sample, trace = (verbose == 2),
                          weights = datasetPairs_sample[, "kernel.value"],
                          size = vecSize[i], maxit = 1000)

    list_nnet[[i]] <- fit_nnet

    if (verbose >= 1)
    {
      cat(i) ; cat(" -- size = ") ; cat(vecSize[i]) ; cat("\n")
    }
  }

  return(list_nnet)
}


#' Predict the values of conditional Kendall's tau
#' using Model Averaging of Neural Networks
#'
#' @param fit result of a call to CKT.fit.nNet
#' @param newData new matrix of observations, with the same number of variables.
#' and same names as the designMatrix that was used to fit the Neural Networks.
#' @param aggregationMethod the method to be used to aggregate all the predictions
#' together. Can be \code{mean} or \code{median}.
#'
#' @return a vector of (predicted) conditional Kendall's taus of the same size
#' as the number of rows of the newData.
#'
#'
#' @references
#' Derumigny, A., & Fermanian, J. D. (2019).
#' A classification point-of-view about conditional Kendall’s tau.
#' Computational Statistics & Data Analysis, 135, 70-94.
#' (Algorithm 7)
#'
#'
#' @examples
#' # We simulate from a conditional copula
#' set.seed(1)
#' N = 800
#' Z = rnorm(n = N, mean = 5, sd = 2)
#' conditionalTau = -0.9 + 1.8 * pnorm(Z, mean = 5, sd = 2)
#' simCopula = VineCopula::BiCopSim(N=N , family = 1,
#'     par = VineCopula::BiCopTau2Par(1 , conditionalTau ))
#' X1 = qnorm(simCopula[,1])
#' X2 = qnorm(simCopula[,2])
#'
#' newZ = seq(2,10,by = 0.1)
#' datasetP = datasetPairs(X1 = X1, X2 = X2, Z = Z, h = 0.07, cut = 0.9)
#' fitCKT_nNets <- CKT.fit.nNets(datasetPairs = datasetP)
#' estimatedCKT_nNets <- CKT.predict.nNets(
#'   fit = fitCKT_nNets, newData = matrix(newZ, ncol = 1))
#'
#' # Comparison between true Kendall's tau (in black)
#' # and estimated Kendall's tau (in red)
#' trueConditionalTau = -0.9 + 1.8 * pnorm(newZ, mean = 5, sd = 2)
#' plot(newZ, trueConditionalTau , col="black",
#'    type = "l", ylim = c(-1, 1))
#' lines(newZ, estimatedCKT_nNets, col = "red")
#'
#' @importFrom nnet nnet
#'
#' @export
#'
CKT.predict.nNets <- function(fit, newData, aggregationMethod = "mean")
{
  length_list_nn = length(fit)
  length_toPredict = length(newData[,1])

  matrixPrediction = matrix(nrow = length_toPredict, ncol = length_list_nn)

  # Prediction
  if (ncol(newData) > 1) {
    for (i_nn in 1:length_list_nn)
    {
      matrixPrediction[, i_nn] = stats::predict(fit[[i_nn]], newData)
    }
  } else {
    colnames(newData) <- "V1"
    for (i_nn in 1:length_list_nn)
    {
      matrixPrediction[, i_nn] = stats::predict(fit[[i_nn]], newData)
    }
  }


  # Aggregation
  prediction = rep(NA, length_toPredict)
  if (aggregationMethod == "mean")
  {
    prediction = rep(0, length_toPredict)
    for (i_nn in 1:length_list_nn)
    {
      prediction = prediction + matrixPrediction[, i_nn]
    }
    prediction = prediction / length_list_nn
  } else if (aggregationMethod == "median") {
    for (iPredict in 1:length_toPredict)
    {
      prediction[iPredict] = stats::median(matrixPrediction[iPredict, ])
    }
  }

  predictCKt = 2 * prediction - 1
  return(predictCKt)
}






