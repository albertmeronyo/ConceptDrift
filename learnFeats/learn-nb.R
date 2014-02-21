library(e1071)

source("evaluate.R")

source("data-pp.R")

# Train model - Naive Bayes
set.seed(5)
nb <- naiveBayes(extended ~ ., trainN) 

# Prediction
pred <- predict(nb, evalN[,-7])
pred <- round(pred)
comp <- data.frame(pred, evalN[,7])
colnames(comp) <- c("predict", "real")

evaluate(comp)
