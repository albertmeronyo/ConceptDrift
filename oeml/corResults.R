f <- read.csv('~/Downloads/effectiveness-study - features.csv')
df <- data.frame(f)
df$X <- NULL
df$X.1 <- NULL
df$dataset <- NULL
df$isTree <- NULL
classifiers <- df$classifier
df$classifier <- NULL
c <- cor(df, use="na.or.complete")
c <- cor(df, use="complete.obs")
c <- cor(df[4:nrow(df),], use="complete.obs")

# Correlations of f and roc
# ROC
c[,ncol(c)]
# f-measure
c[,ncol(c)-1]

require(foreign)
require(nnet)
require(ggplot2)
require(reshape2)

# Predicting classifier (factorial) with the rest (continuous)
# Answer: Multinomial Logistic Regression
mlr <- multinom(classifiers ~ totalSize + nSnapshots + avgGap + avgSize + nInserts + nDeletes + nComm + maxTreeDepth + avgTreeDepth + totalInstances + ratioInstances + ratioInstancesVSIS + totalStructural + ratioStructural + ratioStructuralVSIS, data = df)
summary(mlr)
z <- summary(mlr)$coefficients/summary(mlr)$standard.errors
p <- (1 - pnorm(abs(z), 0, 1)) * 2
