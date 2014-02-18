library(CORElearn)

# Read training and evaluation data
train <- read.csv("~/src/ConceptDrift/learnFeats/feats_train.csv", header=TRUE)
eval <- read.csv("~/src/ConceptDrift/learnFeats/feats_eval.csv", header=TRUE)

trainLabels <- train[,1]
evalLabels<- eval[,1]

# Remove labels
train <- train[,-1]
eval <- eval[,-1]

# Normalization
trainN <- train
evalN <- eval
trainN[,1] <- train[,1]/max(train[,1])
trainN[,2] <- train[,2]/max(train[,2])
trainN[,3] <- train[,3]/max(train[,3])
trainN[,4] <- train[,4]/max(train[,4])
trainN[,5] <- train[,5]/max(train[,5])
trainN[,6] <- train[,6]/max(train[,6])
evalN[,1] <- eval[,1]/max(eval[,1])
evalN[,2] <- eval[,2]/max(eval[,2])
evalN[,3] <- eval[,3]/max(eval[,3])
evalN[,4] <- eval[,4]/max(eval[,4])
evalN[,5] <- eval[,5]/max(eval[,5])
evalN[,6] <- eval[,6]/max(eval[,6])

# Feature selection
# 1. Ranking continuous variables and factor target -> Fisher's F

contvars <- as.list(trainN[,-7])

pvaluecont <- NULL
for (i in 1:6) { pvaluecont[i] <- (oneway.test(contvars[[i]]~trainN$extended))$p.value }
pvaluecont <- matrix(pvaluecont)
row.names(pvaluecont) <- colnames(trainN[,-7])
pvaluecont <- sort(pvaluecont[,1])
pvaluecont

# 2. Any kind of vars and target -> Relief

trainN.matrix <- matrix(colnames(trainN))
attrEval(extended ~ ., trainN, estimator = 'ReliefFexpRank', ReliefIterations = 30)
