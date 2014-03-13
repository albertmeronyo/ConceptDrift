##########################################################
# Pastes columns to preserve identity of instances in OEML
##########################################################

# Read data
df.a <- read.csv('/Users/Albert/src/ConceptDrift/oeml/data/feats-change_3.5.1.csv', header=F)
df.b <- read.csv('/Users/Albert/src/ConceptDrift/oeml/data/feats-change_3.6.csv', header=F)
df.c <- read.csv('/Users/Albert/src/ConceptDrift/oeml/data/feats-change_3.7.csv', header=F)

# If all = F, we only consider nodes in all snapshots
# Otherwise, consider everything and fill with NAs
merged <- merge(df.a, df.b, by="V1", all = T)  
merged <- merge(merged, df.c, by="V1", all = T)

# Target variable: disjunction between targets
merged$V18.x[is.na(merged$V18.x)] <- 0
merged$V18.y[is.na(merged$V18.y)] <- 0
merged$V18[is.na(merged$V18)] <- 0
t <- merged$V18.x + merged$V18.y + merged$V18
t[t > 1] <- 1
merged <- cbind(merged, t)
merged$t <- as.character(merged$t)

# Aemove old targets ones
merged$V18.x <- NULL
merged$V18.y <- NULL
merged$V18 <- NULL

# Rename features
colnames(merged) <- c('resource', 
                      'children0.0', 'children1.0', 'children2.0', 'children3.0', 'parents.0', 'siblings.0', 'members.0', 'membersChildren0.0', 'membersChildren1.0', 'membersChildren2.0', 'membersChildren3.0','ratio.0','ratio0.0','ratio1.0','ratio2.0','ratio3.0',
                      'children0.1', 'children1.1', 'children2.1', 'children3.1', 'parents.1', 'siblings.1', 'members.1', 'membersChildren0.1', 'membersChildren1.1', 'membersChildren2.1', 'membersChildren3.1','ratio.1','ratio0.1','ratio1.1','ratio2.1','ratio3.1',
                      'children0.2', 'children1.2', 'children2.2', 'children3.2', 'parents.2', 'siblings.2', 'members.2', 'membersChildren0.2', 'membersChildren1.2', 'membersChildren2.2', 'membersChildren3.2','ratio.2','ratio0.2','ratio1.2','ratio2.2','ratio3.2',
                      'extended')

# Quote everything
# merged <- data.frame(lapply(merged, as.character), stringsAsFactors=FALSE)

# Save dataset
write.csv(merged, "/Users/Albert/src/ConceptDrift/oeml/data/dbpedia-feats-identity-na-train.csv", quote = TRUE, na = "", row.names = FALSE)
