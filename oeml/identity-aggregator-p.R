##########################################################
# Pastes columns to preserve identity of instances in OEML
##########################################################

args <- commandArgs(trailingOnly = TRUE)
#setwd("/Users/Albert/src/ConceptDrift/oeml")
#args <- c("data/feats-change_3.5.1.csv", "data/feats-change_3.6.csv", "data/feats-change_3.7.csv", "data/feats-change_3.9.csv", "baz.csv")

input.files <- head(args,-2)
output.file <- tail(args,1)
print(paste("Input file: ", input.files))
print(paste("Output file: ", output.file))

# Read all data files except last (eval dataset)
all <- lapply(input.files, read.csv, header=F)

merged <- data.frame(all[1])

if (length(input.files) > 1) {
    num.feats <- ncol(merged)
    for (i in 2:length(all)) {
        df <- data.frame(all[i])
        # If all = F, we only consider nodes in all snapshots
        # Otherwise, consider everything and fill with NAs
        merged <- merge(merged, df, by=1, all = F)  
    }

    # List of column numbers where target variables lie
    targets <- c()
    for (i in num.feats:length(merged)) {
        if (i %% (num.feats - 1) == 0) {
            targets <- c(targets, i)
        }  
    }
    targets <- targets + 1
    targets <- c(num.feats, targets)

    # Target variable: disjunction between targets
    # If NA is present some change happened
    for (i in targets) {
        merged[is.na(merged[,i]),i] <- 1
    }

    t <- merged[,targets[1]]
    for (i in targets[2:length(targets)]) {
        t <- t + merged[,i]
    }
    t[t > 1] <- 1
    merged <- cbind(merged, t)
    merged$t <- as.character(merged$t)

    # Remove old targets ones
    j <- 0
    for (i in targets) {
        merged[,i - j] <- NULL
        j <- j + 1
    }
}

# Remove instance names
merged[,1] <- NULL

# Rename features
#colnames(merged) <- c('resource', 
#                      'children0.0', 'children1.0', 'children2.0', 'children3.0', 'parents.0', 'siblings.0', 'members.0', 'membersChildren0.0', 'membersChildren1.0', 'membersChildren2.0', 'membersChildren3.0','ratio.0','ratio0.0','ratio1.0','ratio2.0','ratio3.0',
#                      'children0.1', 'children1.1', 'children2.1', 'children3.1', 'parents.1', 'siblings.1', 'members.1', 'membersChildren0.1', 'membersChildren1.1', 'membersChildren2.1', 'membersChildren3.1','ratio.1','ratio0.1','ratio1.1','ratio2.1','ratio3.1',
#                      'children0.2', 'children1.2', 'children2.2', 'children3.2', 'parents.2', 'siblings.2', 'members.2', 'membersChildren0.2', 'membersChildren1.2', 'membersChildren2.2', 'membersChildren3.2','ratio.2','ratio0.2','ratio1.2','ratio2.2','ratio3.2',
#                      'extended')

# Quote everything
# merged <- data.frame(lapply(merged, as.character), stringsAsFactors=FALSE)

# Save dataset
write.csv(merged, output.file, quote = TRUE, na = "", row.names = FALSE)
