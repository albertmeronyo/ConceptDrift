# Evaluation function with stats

# Error and confusion matrix
evaluate <- function(comp) {
    error <- nrow(comp[comp$predict != comp$real,])/nrow(comp)
    confusion <- table(pred, eval[,7])
    tn <- confusion[1,1]
    fn <- confusion[1,2]
    fp <- confusion[2,1]
    tp <- confusion[2,2]
    precision <- tp / (tp + fp)
    recall <- tp / (tp + fn)
    f <- 2 * (precision * recall) / (precision + recall)
    print(confusion)
    print(paste("precision: " , precision))
    print(paste("recall: ", recall))
    print(paste("f-measure: ", f))
}

