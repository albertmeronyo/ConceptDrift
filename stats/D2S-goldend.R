library(SPARQL)
library(gdata)

####################
# Read configuration
####################
source('config.R')

##########################
# Retrieve data via SPARQL
##########################
options <- NULL
prefix <- c()

# Fill pattern of observations and FILTER clauses, dataset A
a.projections.pattern <- ""
a.variable.pattern <- ""
a.labels.pattern <- ""
a.values.pattern <- ""
for (i in 1:length(a.variables.names)) {
    a.projections.pattern <- paste(a.projections.pattern,
                                   ' (str(?',
                                   a.variables.names[i],
                                   ') AS ?',
                                   a.variables.names[i],
                                   ') ', sep = '')
    a.variable.pattern <- paste(a.variable.pattern,
                                a.variables.predicates[i], ' ?',
                                a.variables.names[i], '_v ; ',
                                sep = '')
    a.labels.pattern <- paste(a.labels.pattern, ' ?',
                              a.variables.names[i],
                              '_v skos:prefLabel ?',
                              a.variables.names[i],
                              ' . ',
                              sep = '')
    if (length(a.variables.values[[i]] > 0)) {
        a.values.pattern <- paste(a.values.pattern, "FILTER (")
        a.values.pattern <- paste(a.values.pattern,
                                  ' ?', a.variables.names[i],
                                  '_v IN (', sep = '')
        for (j in 1:length(a.variables.values[[i]])) {
            a.values.pattern <- paste(a.values.pattern,
                                      a.variables.values[[i]][j])
            if (j < length(a.variables.values[[i]])) {
                a.values.pattern <- paste(a.values.pattern, ', ')
            }        
        }
        a.values.pattern <- paste(a.values.pattern, '))')
    }
}

# Fill pattern of observations and FILTER clauses, dataset B
b.projections.pattern <- ""
b.variable.pattern <- ""
b.labels.pattern <- ""
b.values.pattern <- ""
for (i in 1:length(b.variables.names)) {
    b.projections.pattern <- paste(b.projections.pattern,
                                   ' (str(?',
                                   b.variables.names[i],
                                   ') AS ?',
                                   b.variables.names[i],
                                   ') ', sep = '')
    b.variable.pattern <- paste(b.variable.pattern,
                                b.variables.predicates[i], ' ?',
                                b.variables.names[i], '_v ; ',
                                sep = '')
    b.labels.pattern <- paste(b.labels.pattern, ' ?',
                              b.variables.names[i],
                              '_v skos:prefLabel ?',
                              b.variables.names[i],
                              ' . ',
                              sep = '')
    if (length(b.variables.values[[i]] > 0)) {
        b.values.pattern <- paste(b.values.pattern, "FILTER (")
        b.values.pattern <- paste(b.values.pattern,
                                  ' ?', b.variables.names[i],
                                  '_v IN (', sep = '')
        for (j in 1:length(b.variables.values[[i]])) {
            b.values.pattern <- paste(b.values.pattern,
                                      b.variables.values[[i]][j])
            if (j < length(b.variables.values[[i]])) {
                b.values.pattern <- paste(b.values.pattern, ', ')
            }        
        }
        b.values.pattern <- paste(b.values.pattern, '))')
    }
}

a.query <- paste(prefixes,
                 "SELECT DISTINCT",
                 a.projections.pattern,
                 "?population FROM <",
                 a.graph,
                 "> WHERE { ?cell d2s:isObservation [",
                 a.variable.pattern,
                 a.numeric.predicate,
                 " ?population ] . ?occupation_v skos:broader ?occ_subclass . ?occ_subclass skos:broader ?occ_class . ?occ_class skos:broader ?municipality .",
                 a.labels.pattern,
                 a.values.pattern,
                 "} LIMIT 100", sep = '')
           
b.query <- paste(prefixes,
                 "SELECT DISTINCT",
                 b.projections.pattern,
                 "?population FROM <",
                 b.graph,
                 "> WHERE { ?cell d2s:isObservation [",
                 b.variable.pattern,
                 b.numeric.predicate,
                 " ?population ] .",
                 b.labels.pattern,
                 b.values.pattern,
                 "} LIMIT 100", sep = '') 

a.res <- SPARQL(endpoint, a.query, ns = prefix, extra = options)$results
b.res <- SPARQL(endpoint, b.query, ns = prefix, extra = options)$results

#############
# Pre-process
#############
# Data.frame for first dataset, removing all totals
df <- data.frame(a.res[-grep("(Totaal|totaal)", a.res$occupation_c), ])
# Remove all rows with NAs
df <- df[complete.cases(df), ]
# Remove possibly duplicated rows
df <- df[!duplicated(df), ]
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
h1 <- read.xls('1889_08_T1.xls')
h1$ID <- NULL
h1$ALTBEROEP <- NULL 
h1$STATUS <- NULL 
h1$REL <- NULL
h1 <- h1[complete.cases(h1),]
df.hisco <- merge(df, h1, by.y=c("BEROEP","POSITIE"), by.x=c("occupation_c","position_c"))
df.hisco <- df.hisco[!duplicated(df.hisco),]
df.hisco$HISCO <- as.factor(df.hisco$HISCO)

# Data.frame for second dataset, removing all totals
df2 <- data.frame(b.res[-grep("(Totaal|totaal)", b.res$occupation_c),])
# We also remove the totals for the whole province ("Geheele Provincie")
df2 <- data.frame(df2[-grep("Geheele", df2$municipality_c),])
# (OPTIONAL) Remove all rows with non-identified municipalities ("Gemeentes met...")
df2 <- data.frame(df2[-grep("Gemeenten met", df2$municipality_c),])
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
h2 <- read.xls('1899_04_T.xls')
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

################################################
# Process: Wilcoxon test on provided data arrays
################################################
p <- wilcox.test(a.res[,'population'], 
                 b.res[,'population'])
p$p.value
