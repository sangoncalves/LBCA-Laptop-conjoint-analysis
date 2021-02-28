#######################################################################
### Function for predicting preference shares from a MNL model with ### 
### bootstrap percentiles prediction intervals                      ### 
#######################################################################

# model: mlogit object returned by mlogit()
# data: a data frame containing the set of designs for which you want to 
#       predict shares.  Same format of the data used to estimate model. 
# nsim: number of bootstrap samples, default is 500
# conflevel: desired confidence level, default is 0.95
# nresp: number of representative respondents, default is 1000
# library "parallel" is necessary

BootCI.predict.mixed.mnl <- function(model, data, nsim=500, conflevel=0.95, nresp=1000) {
  dataModel <- model$model
  dataModel$probabilities <- NULL
  dataModel$linpred <- NULL
  idx <- dataModel$idx 
  dataModel$idx <- NULL
  dataModel <- data.frame(dataModel, idx)
  idVar <- unique(dataModel[,names(idx)[1]])
  
  bootstrapping <- function(x) {
    idbootsamp <- data.frame(sample(idVar, replace=T))
    names(idbootsamp) <- names(idx)[1]
    bootsamp <- merge(idbootsamp, dataModel, by=names(idx)[1], all.x=T)
    bootsamp[,names(idx)[1]] <- rep(1:length(table(idx[,1])), each=length(table(idx[,3])))
    bootsamp.mlogit  <- dfidx(bootsamp, idx = list(c(names(idx)[1:2]), names(idx)[3]),
                              drop.index=F)    
    bootfit <- update(model, data = bootsamp.mlogit)
    data.model <- model.matrix(update(bootfit$formula, 0 ~ .), data = data)[,-1]
    coef.Sigma <- cov.mlogit(bootfit)
    coef.mu <- bootfit$coef[1:dim(coef.Sigma)[1]]
    draws <- mvrnorm(n=nresp, coef.mu, coef.Sigma)
    shares <- matrix(NA, nrow=nresp, ncol=nrow(data))
    for (i in 1:nresp) {
      utility <- data.model%*%draws[i,]
      share <- exp(utility)/sum(exp(utility))
      shares[i,] <- share
    }
    colMeans(shares)
  }
  
  cl <- makeCluster(detectCores())
  clusterEvalQ(cl, {
    library(mlogit)
    library(MASS) })
  clusterExport(cl, varlist=c("idVar", "dataModel", "idx", "model", "data", "nresp", 
                              paste(model$call$rpar)), envir=environment())
  bootdistr <- parLapply(cl, 1:nsim, fun=bootstrapping)
  stopCluster(cl)
  
  bootdistr <- do.call(cbind, bootdistr)
  lowl <- (1-conflevel)/2
  upl <- 1-lowl  
  bootperc <- t(apply(bootdistr, 1, function(x) quantile(x, probs=c(lowl, upl))))
  pointpred <- predict.mixed.mnl(model, data, nresp)
  predictedShares <- cbind(pointpred[,1], bootperc, pointpred[,2:ncol(pointpred)])
  names(predictedShares)[1] <- "share" 
  predictedShares
}