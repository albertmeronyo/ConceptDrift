library(nnet)

train <- read.csv("src/ConceptDrift/learnFeats/feats_train.csv", header=TRUE)
eval <- read.csv("src/ConceptDrift/learnFeats/feats_eval.csv", header=TRUE)

neural <- nnet(train[,-7], train[,7], size = 8)