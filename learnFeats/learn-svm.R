library(e1071)

source('evaluate.R')

source('data-pp.R')


# Train model - SVM
# svp <- ksvm(train_n[,7],train_labels,type="C-svc",kernel='besseldot',C=100,scaled=c())
svm.model <- svm(extended ~ ., data = trainN, cost = 100, gamma = 1)


# Prediction
pred <- predict(svm.model, eval_n[,-7])
pred <- round(pred)
comp <- data.frame(pred, eval_n[,7])
colnames(comp) <- c("predict", "real")

# Error and confusion matrix
nrow(comp[comp$predict != comp$real,])/nrow(comp)
table(pred, eval[,7])
