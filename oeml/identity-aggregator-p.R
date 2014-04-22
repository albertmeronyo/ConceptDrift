##########################################################
# Pastes columns to preserve identity of instances in OEML
##########################################################

args <- commandArgs(trailingOnly = TRUE)

input.files <- head(args,-2)
output.file <- head(tail(args,2),1)
in.all.snaps <- tail(args,1)
print(paste("Input file: ", input.files))
print(paste("Output file: ", output.file))
print(paste("Non-common: ", in.all.snaps))

# Read all data files except last (eval dataset)
all <- lapply(input.files, read.csv, header=F)

merged <- data.frame(all[1])

if (length(input.files) > 1) {
    num.feats <- ncol(merged)
    for (i in 2:length(all)) {
        df <- data.frame(all[i])
        # If all = F, we only consider nodes in all snapshots
        # Otherwise, consider everything and fill with NAs
        merged <- merge(merged, df, by=1, all = in.all.snaps)  
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
colnames(merged) <- as.character(seq(1:length(colnames(merged))))

# Save dataset
write.csv(merged, output.file, quote = TRUE, na = "", row.names = FALSE)
