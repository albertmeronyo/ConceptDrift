require(gdata)
require(FactoMineR)
require(MASS)
require(ggplot2)

###########################
# Load CSV with SPARQL dump
###########################
res <- read.csv('/Users/Albert/src/ConceptDrift/semStats/data/occupations-overijssel-1899.csv', header = TRUE)
a <- res

################################
# Removal of column "population"
################################

# We use the population column to repeat the rows as many times as this column specifies
# Then we remove the column
a <- a[rep(1:nrow(a), a$population),]
a$population <- NULL

#####
# MCA
#####
cats_a <- apply(a, 2, function(x) nlevels(as.factor(x)))

# MCA of the MASS package
mca_a <- mca(a, nf = 5)

# Plots
mca_a_vars_df <- data.frame(mca_a$cs, Variable = rep(names(cats_a), cats_a))
ggplot(data = mca_a_vars_df, aes(x = X1, y = X2, label = rownames(mca_a_vars_df))) + geom_hline(yintercept = 0, colour = "gray70") + geom_vline(xintercept = 0, colour = "gray70") + geom_text(aes(colour = Variable)) + ggtitle("BRT-1899 dataset in Overijssel")
