library(nnet)

source("evaluate.R")

source("data-pp.R")

# Train model - neural network
set.seed(4)
neural <- nnet(trainN[,-7], trainN[,7], size = 8, entropy = T, decaying = 0, maxit = 1000)

# Train model - Naive Bayes
# set.seed(5)
# nb <- naiveBayes(trainN[,-7], trainN[,7]) 

# Prediction
pred <- predict(neural, evalN[,-7])
pred <- round(pred)
comp <- data.frame(pred, evalN[,7])
colnames(comp) <- c("predict", "real")

evaluate(comp)

