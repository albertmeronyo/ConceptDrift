require(gdata)
require(FactoMineR)
require(MASS)
require(ggplot2)

#######################################
# Load source data from Excel originals
################################################
# TODO: Load from endpoint and study differences
################################################

# First dataset: BRT_1909_02A1_T1 and BRT_1909_02A2_T1
res <- read.csv('/Users/Albert/src/ConceptDrift/semStats/data/occupations-tt-1947.csv', header = TRUE)

#############
# Pre-process
#############
# Data.frame for first dataset, removing all totals
df <- data.frame(res[-grep("Totaal", res$occupation_label),])
# Remove all rows with NAs
df <- df[complete.cases(df),]
# Remove possibly duplicated rows
df <- df[!duplicated(df),]
# Assign column data types
df$age_label <- as.factor(df$age_label)
df$sex_label <- as.factor(df$sex_label)
df$province_label <- as.factor(df$province_label)
df$occupation_label <- as.factor(df$occupation_label)
df$population <- as.numeric(df$population)

################################
# Removal of column "population"
################################

# We use the population column to repeat the rows as many times as this column specifies
# Then we remove the column
df <- df[rep(1:nrow(df), df$population),]
df$population <- NULL
df$row.names <- NULL

df <- df[complete.cases(df),]

#####
# MCA
#####

# Sampled data
sample <- df[sample(1:nrow(df), 100000, replace=FALSE),]

cats <- apply(sample, 2, function(x) nlevels(as.factor(x)))

# MCA of the MASS package
mca_a <- MCA(sample)

# Plots (factominer)
plot.MCA(mca_a, invisible=c("ind"))

# Plots (mass)
mca_vars_df <- data.frame(mca_a$cs, Variable = rep(names(cats), cats))
ggplot(data = mca_vars_df, aes(x = X1, y = X2, label = rownames(mca_vars_df))) + geom_hline(yintercept = 0, colour = "gray70") + geom_vline(xintercept = 0, colour = "gray70") + geom_text(aes(colour = Variable)) + ggtitle("MCA plot of variables using R package MASS")
