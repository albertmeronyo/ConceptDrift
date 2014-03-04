require(gdata)
require(FactoMineR)
require(MASS)
require(ggplot2)

###########################
# Load CSV with SPARQL dump
###########################
res <- read.csv('/Users/Albert/src/ConceptDrift/stats/BRT_1889_08_T1.csv', header = TRUE)
res2 <- read.csv('/Users/Albert/src/ConceptDrift/stats/BRT_1899_04_T.csv', header = TRUE)

#############
# Pre-process
#############
# Data.frame for first dataset, removing all totals
df <- data.frame(res[-grep("(Totaal|totaal)", res$occupation_c),])
# Remove all rows with NAs
df <- df[complete.cases(df),]
# Remove possibly duplicated rows
df <- df[!duplicated(df),]
# Assign column data types
df$age_c <- as.factor(df$age_c)
df$gender_c <- as.factor(df$gender_c)
df$marital_status_c <- as.factor(df$marital_status_c)
df$municipality_c <- as.factor(df$municipality_c)
df$occ_class_c <- as.factor(df$occ_class_c)
df$occ_subclass_c <- as.factor(df$occ_subclass_c)
df$occupation_c <- as.factor(df$occupation_c)
df$position_c <- as.factor(df$position_c)
df$population <- as.numeric(df$population)
# Load HISCO data and merge
h1 <- read.xls('/Users/Albert/src/ConceptDrift/stats/1889_08_T1.xls')
h1$ID <- NULL
h1$ALTBEROEP <- NULL 
h1$STATUS <- NULL 
h1$REL <- NULL
h1 <- h1[complete.cases(h1),]
df.hisco <- merge(df, h1, by.y=c("BEROEP","POSITIE"), by.x=c("occupation_c","position_c"))
df.hisco <- df.hisco[!duplicated(df.hisco),]
df.hisco$HISCO <- as.factor(df.hisco$HISCO)

# Data.frame for second dataset, removing all totals
df2 <- data.frame(res2[-grep("(Totaal|totaal)", res2$occupation_c),])
# We also remove the totals for the whole province ("Geheele Provincie")
df2 <- data.frame(df2[-grep("Geheele", df2$municipality_c),])
# (OPTIONAL) Remove all rows with non-identified municipalities ("Gemeenten met...")
df2 <- data.frame(df2[-grep("Gemeenten met", df2$municipality_c),])
# Update list of levels (we just removed some)
df2$municipality_c <- factor(df2$municipality_c)
# Remove all rows with NAs
df2 <- df2[complete.cases(df2),]
# Assign column data types
df2$age_c <- as.factor(df2$age_c)
df2$gender_c <- as.factor(df2$gender_c)
df2$marital_status_c <- as.factor(df2$marital_status_c)
df2$municipality_c <- as.factor(df2$municipality_c)
df2$occupation_c <- as.factor(df2$occupation_c)
df2$position_c <- as.factor(df2$position_c)
df2$population <- as.numeric(df2$population)
# Load HISCO data and merge
h2 <- read.xls('/Users/Albert/src/ConceptDrift/stats/1899_04_T.xls')
h2$ID <- NULL
h2$ALTBEROEP <- NULL 
h2$STATUS <- NULL 
h2$REL <- NULL
h2 <- h2[complete.cases(h2),]
df2.hisco <- merge(df2, h2, by.y=c("BEROEP","POSITIE"), by.x=c("occupation_c","position_c"))
df2.hisco <- df2.hisco[!duplicated(df2.hisco),]
df2.hisco$HISCO <- as.factor(df2.hisco$HISCO)

# Now we extract the lists of HISCO codes for both years
hcodes <- c()
for(hcode in levels(df.hisco$HISCO)) {
  hcodes <- append(hcodes, hcode)
}
hcodes2 <- c()
for(hcode in levels(df2.hisco$HISCO)) {
  hcodes2 <- append(hcodes2, hcode)
}
# Common HISCO codes between the two years
common.hcodes <- intersect(hcodes, hcodes2)

##############################
# Manual dataset harmonization
##############################

a <- df.hisco
b <- df2.hisco

# Removal of non-common or not useful columns
a$occupation <- NULL
a$occupation_c <- NULL
a$occ_class_c <- NULL
a$occ_subclass_c <- NULL

b$occupation_c <- NULL
b$occupation <- NULL

# Position: removal of factor 'Z'
a <- subset(a, !a$position_c %in% c('Z'))
a$position_c <- factor(a$position_c)

# Municipality
# Source error: in a, 'X' should be 'Amsterdam' and 'III' should be 'Den Helder'
levels(a$municipality_c) <- c('Alkmaar', 'Amsterdam', 'Edam', 'Enkhuizen', 'Haarlem', 'Haarlemmermeer', 'Hilversum', 'Hoorn', 'Den Helder', 'Nieuwer Amstel', 'Purmerend', 'Sloten', 'Texel', 'Velsen', 'Weesp', 'Amsterdam', 'Haarlem', 'Zaandam')
# Make values consistent in b
levels(b$municipality_c) <- c('Alkmaar', 'Amsterdam', 'Beverwijk', 'Bloemendaal', 'Bussum', 'Edam', 'Enkhuizen', 'Haarlem', 'Haarlemmermeer', 'Den Helder', 'Hilversum', 'Hoorn', 'Nieuwer Amstel', 'Purmerend', 'Sloten', 'Texel', 'Velzen', 'Weesp', 'Wormerveer', 'Zaandam')

# Age
# Age names
levels(a$age_c) <- c('12 years', '13 years', '14 to 15 years', '16 to 17 years', '18 to 22 years', 'Less than 12 years', '23 to 24 years', '25 to 35 years', '36 to 50 years', '51 to 60 years', '61 to 65 years', '66 to 70 years', 'More than 71 years', 'Geboortejaren.  leeftijd in j.', 'Unknown age')
levels(b$age_c) <- c('12 to 13 years', '14 to 15 years', '16 to 17 years', '18 to 22 years', '23 to 35 years', '36 to 50 years', '51 to 60 years', '61 to 65 years', '66 to 70 years', 'More than 71 years', 'Less than 12 years')
# Age ranges: merge rows in dataframe a of 12 and 13 years, and 23-24 and 25-35
levels(a$age_c) <- c('12 to 13 years', '12 to 13 years', '14 to 15 years', '16 to 17 years', '18 to 22 years', 'Less than 12 years', '23 to 35 years', '23 to 35 years', '36 to 50 years', '51 to 60 years', '61 to 65 years', '66 to 70 years', 'More than 71 years', 'Geboortejaren.  leeftijd in j.', 'Unknown age')

# Gender / marital status
levels(a$gender_c) <- c('Male', 'Female')
levels(b$gender_c) <- c('Male', 'Female')
levels(a$marital_status_c) <- c('Married', 'Unmarried')
levels(b$marital_status_c) <- c('Married', 'Unmarried')

# Aggregate all observations that share *all* factors, except maybe population
a <- with(a, aggregate(population, by = list(position_c = position_c, age_c = age_c, gender_c = gender_c, marital_status_c = marital_status_c, municipality_c = municipality_c, HISCO = HISCO), FUN = sum))
b <- with(b, aggregate(population, by = list(position_c = position_c, age_c = age_c, gender_c = gender_c, marital_status_c = marital_status_c, municipality_c = municipality_c, HISCO = HISCO), FUN = sum))
colnames(a) <- c('position', 'age', 'gender', 'marital_status', 'municipality', 'hisco', 'population')
colnames(b) <- c('position', 'age', 'gender', 'marital_status', 'municipality', 'hisco', 'population')

# Now the dataset looks OK, but we remove 'Unknown age', 'Leeftijd...' and empty cells because they look as incomplete or missing data
a <- subset(a, !a$age %in% c('Unknown age', 'Geboortejaren.  leeftijd in j.'))
a$age <- factor(a$age)
a <- subset(a, !a$position %in% c(''))
a$position <- factor(a$position)
b <- subset(b, !b$position %in% c(''))
b$position <- factor(b$position)

# HISCO code -1 means "no mapping" and -2 means "Unemployed".
# -2 could be interesting, but -1 seems to be introducing noise and we delete it
a <- subset(a, !a$hisco %in% c('-1'))
a$hisco <- factor(a$hisco)
b <- subset(b, !b$hisco %in% c('-1'))
b$hisco <- factor(b$hisco)

a$hisco <- as.factor(a$hisco)
b$hisco <- as.factor(b$hisco)

################################
# Removal of column "population"
################################

# We use the population column to repeat the rows as many times as this column specifies
# Then we remove the column
a <- a[rep(1:nrow(a), a$population),]
b <- b[rep(1:nrow(b), b$population),]
a$population <- NULL
b$population <- NULL

# Save to CSV
write.table(a, file='/Users/Albert/src/ConceptDrift/stats/BRT_1889_NH_pp.csv', sep=',', row.names=F)
write.table(b, file='/Users/Albert/src/ConceptDrift/stats/BRT_1899_NH_pp.csv', sep=',', row.names=F)

#####
# MCA
#####

cats_a <- apply(a, 2, function(x) nlevels(as.factor(x)))
cats_b <- apply(b, 2, function(x) nlevels(as.factor(x)))

# MCA of the FactoMineR package
mca1_a <- MCA(a, graph = FALSE)
mca1_b <- MCA(b, graph = FALSE)

# MCA of the MASS package
mca2_a <- mca(a, nf = 5)
mca2_b <- mca(b, nf = 5)

# Plots
mca2_a_vars_df <- data.frame(mca2_a$cs, Variable = rep(names(cats_a), cats_a))
ggplot(data = mca2_a_vars_df, aes(x = X1, y = X2, label = rownames(mca2_a_vars_df))) + geom_hline(yintercept = 0, colour = "gray70") + geom_vline(xintercept = 0, colour = "gray70") + geom_text(aes(colour = Variable)) + ggtitle("MCA plot of variables using R package MASS")
mca2_b_vars_df <- data.frame(mca2_b$cs, Variable = rep(names(cats_b), cats_b))
ggplot(data = mca2_b_vars_df, aes(x = X1, y = X2, label = rownames(mca2_b_vars_df))) + geom_hline(yintercept = 0, colour = "gray70") + geom_vline(xintercept = 0, colour = "gray70") + geom_text(aes(colour = Variable)) + ggtitle("MCA plot of variables using R package MASS")
