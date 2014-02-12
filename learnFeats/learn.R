library(nnet)
library(e1071)

# Read training and evaluation data
train <- read.csv("src/ConceptDrift/learnFeats/feats_train.csv", header=TRUE)
eval <- read.csv("src/ConceptDrift/learnFeats/feats_eval.csv", header=TRUE)

# Remove labels
train <- train[,-1]
eval <- eval[,-1]

# Normalization
train_n <- train
eval_n <- eval
train_n[,1] <- train[,1]/max(train[,1])
train_n[,2] <- train[,2]/max(train[,2])
train_n[,3] <- train[,3]/max(train[,3])
train_n[,4] <- train[,4]/max(train[,4])
train_n[,5] <- train[,5]/max(train[,5])
train_n[,6] <- train[,6]/max(train[,6])
eval_n[,1] <- eval[,1]/max(eval[,1])
eval_n[,2] <- eval[,2]/max(eval[,2])
eval_n[,3] <- eval[,3]/max(eval[,3])
eval_n[,4] <- eval[,4]/max(eval[,4])
eval_n[,5] <- eval[,5]/max(eval[,5])
eval_n[,6] <- eval[,6]/max(eval[,6])

# Train model - neural network
set.seed(3)
neural <- nnet(train_n[,-7], train_n[,7], size = 20, entropy=T, maxit=1000)

# Train model - Naive Bayes
set.seed(5)
nb <- naiveBayes(train_n[,-7], train_n[,7]) 

# Prediction
pred <- predict(nb, eval_n[,-7])
comp <- data.frame(pred, eval_n[,7])
colnames(comp) <- c("predict", "real")

# Error and confusion matrix
nrow(comp[comp$predict != comp$real,])/nrow(comp)
table(pred, eval[,7])
