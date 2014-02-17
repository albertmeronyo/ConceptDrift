library(e1071)

# Read training and evaluation data
train <- read.csv("~/src/ConceptDrift/learnFeats/feats_train.csv", header=TRUE)
eval <- read.csv("~/src/ConceptDrift/learnFeats/feats_eval.csv", header=TRUE)

train_labels <- train[,1]
eval_labels <- eval[,1]

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

# Train model - Naive Bayes
set.seed(5)
nb <- naiveBayes(train_n[,-7], train_n[,7]) 

# Prediction
pred <- predict(nb, eval_n[,-7])
pred <- round(pred)
comp <- data.frame(pred, eval_n[,7])
colnames(comp) <- c("predict", "real")

# Error and confusion matrix
error <- nrow(comp[comp$predict != comp$real,])/nrow(comp)
confusion <- table(pred, eval[,7])
tn <- confusion[1,1]
fn <- confusion[1,2]
fp <- confusion[2,1]
tp <- confusion[2,2]
precision <- tp / (tp + fp)
recall <- tp / (tp + fn)
f <- 2 * (precision * recall) / (precision + recall)
confusion
print(paste("precision: " , precision))
print(paste("recall: ", recall))
print(paste("f-measure: ", f))
