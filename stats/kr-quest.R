library(SPARQL)
library(gdata)

##########################
# Retrieve data via SPARQL
##########################
endpoint <- "http://lod.cedar-project.nl:8080/sparql/cedar"
options <- NULL
#prefix <- c("lop","http://semanticweb.cs.vu.nl/poseidon/ns/instances/",
#            "eez","http://semanticweb.cs.vu.nl/poseidon/ns/eez/")
prefix <- c()
sparql_prefix <- "PREFIX d2s: <http://www.data2semantics.org/core/>
                  PREFIX cd: <http://www.data2semantics.org/data/BRT_1889_08_T1_marked/Tabel_1/>
                  PREFIX ns1: <http://www.data2semantics.org/core/Tabel_1/>
                  PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"
q <- paste(sparql_prefix,"SELECT DISTINCT (str(?age_s) AS ?age_c) (str(?gender_s) AS ?gender_c) (str(?marital_status_s) AS ?marital_status_c) (str(?municipality_s) AS ?municipality_c) (str(?occ_class_s) AS ?occ_class_c) (str(?occ_subclass_s) AS ?occ_subclass_c) (str(?occupation_s) AS ?occupation_c) ?occupation (REPLACE(?position_s, \"^ +| +$\", \"\") AS ?position_c) ?population
FROM <http://lod.cedar-project.nl/resource/BRT_1889_08_T1>
WHERE {
           ?cell d2s:isObservation [ d2s:dimension ?gender ;
           d2s:dimension ?marital_status ;
           d2s:dimension ?age ;
           ns1:BENAMING_van_de_onderdeelen_der_onderscheidene_beroepsklassen__met_de_daartoe_behoordende_beroepen ?occupation ;
           d2s:populationSize ?population ] .
           OPTIONAL {
           ?cell d2s:isObservation [ns1:Positie_in_het_beroep__aangeduid_met_A__B__C_of_D_ ?position] .
           ?position skos:prefLabel ?position_s .
           }
           
           ?occupation skos:broader ?occ_subclass .
           ?occ_subclass skos:broader ?occ_class .
           ?occ_class skos:broader ?municipality .
           ?municipality skos:prefLabel ?municipality_s .
           ?occ_class skos:prefLabel ?occ_class_s .
           ?occ_subclass skos:prefLabel ?occ_subclass_s .
           ?cell d2s:cell ?cell_s .
           ?age skos:prefLabel ?age_s .
           ?gender skos:prefLabel ?gender_s .
           ?marital_status skos:prefLabel ?marital_status_s .
           ?occupation skos:prefLabel ?occupation_s .
           
           FILTER (?gender IN (cd:M, cd:V))
           FILTER (?marital_status IN (cd:O, cd:G))
           FILTER (?age IN (cd:12___1878, cd:13___1876, cd:14_---_15__1875___---_1874, cd:16_---_17__1873___---_1872, cd:1878_en_later__beneden_12_j_, cd:18_---_22__1871___---_1867, cd:Geboortejaren___leeftijd_in_j_, cd:25_---_35__1864___---_1854, cd:36_---_50__1853___---_1839, cd:51_---_60__1838___---_1829, cd:61_---_65__1828___---_1824, cd:66_---_70__1823_---_1818, cd:71_en_daarboven__1818_en_vroeger, cd:Van_onbekenden_leeftijd, cd:23_---_24__1866___---_1865))
           } ORDER BY (?cell)")

sparql_prefix2 <- "PREFIX d2s: <http://www.data2semantics.org/core/>
PREFIX cd: <http://www.data2semantics.org/data/BRT_1899_04_T_marked/Noordholland/>
PREFIX ns1: <http://www.data2semantics.org/core/Noordholland/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"

q2 <- paste(sparql_prefix2,
            "SELECT DISTINCT (str(?age_s) AS ?age_c) (str(?gender_s) AS ?gender_c) (str(?marital_status_s) AS ?marital_status_c) (str(?municipality_s) AS ?municipality_c) ?occupation (str(?occupation_s) AS ?occupation_c) (str(?position_s) AS ?position_c) ?population
FROM <http://lod.cedar-project.nl/resource/BRT_1899_04_T>
WHERE {
            ?cell d2s:isObservation [ d2s:dimension ?gender ;
            d2s:dimension ?marital_status ;
            d2s:dimension ?age ;
            ns1:Benaming_van_de_onderdeelen_der_onderscheidene_beroepsklassen__met_de_daartoe_behoorende_beroepen ?occupation ;
            ns1:Gemeenten ?municipality ;
            d2s:populationSize ?population ] .
            OPTIONAL {
            ?cell d2s:isObservation [ ns1:Positie_in_het_beroep ?position ] .
            ?position skos:prefLabel ?position_s .
            }
            
            ?cell d2s:cell ?cell_s .
            ?age skos:prefLabel ?age_s .
            ?gender skos:prefLabel ?gender_s .
            ?marital_status skos:prefLabel ?marital_status_s .
            ?occupation skos:prefLabel ?occupation_s .
            ?municipality skos:prefLabel ?municipality_s .
            
            FILTER (?gender IN (cd:MANNEN, cd:VROUWEN))
            FILTER (?marital_status IN (cd:O_, cd:G_))
            FILTER (?age IN (cd:12_of_13_1887_-_1886, cd:14_of_15_1885_-_1884, cd:16_of_17_1883_-_1882, cd:18_-_22_1881_-_1877, cd:23_-_35_1876_-_1864, cd:beneden_12_jaar_1888_en_later, cd:51_-_60_1848_-_1839, cd:61_-_65_1838_-_1834, cd:66_-_70_1833_-_1829, cd:71_en_daarboven_1828_en_vroeger, cd:36_-_50_1863_-_1849))
            } ORDER BY (?cell)") 

res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results
res2 <- SPARQL(endpoint,q2,ns=prefix,extra=options)$results

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
df2 <- data.frame(res2[-grep("(Totaal|totaal)", res2$occupation_c),])
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

######################################################
# Process: Wilcoxon test over all HISCO class pairings
######################################################
pvalues <- c()
for(h in common.hcodes) {
  p <- wilcox.test(df.hisco[df.hisco$HISCO == h,'population'], 
                   df2.hisco[df2.hisco$HISCO == h,'population'])
  pvalues <- append(pvalues, p$p.value)
}
hp <- data.frame(common.hcodes, pvalues)
hp <- hp[complete.cases(hp),]
hp <- hp[order(hp$pvalues),]
# Select only the ones clearly refusing H_0 (p-values under 0.05)
hp.safe <- hp[hp$pvalues < 0.05,]

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
levels(a$municipality_c) <- c('Alkmaar', 'Amsterdam', 'Edam', 'Enkhuizen', 'Haarlem', 'Haarlemmermeer', 'Hilversum', 'Hoorn', 'Den Helder', 'Nieuwer Amstel', 'Purmerend', 'Sloten', 'Texel', 'Velsen', 'Weesp', 'Amsterdam', 'Zaandam')
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

###################################################################
# Data reformatting for Formal Concept Analysis (FCA) python script
###################################################################

# For each HISCO code, generate a pair with the code itself and its attribute
# We'll generate concept lattices for datasets a and b
relation.a <- data.frame(num=rep(NA, 2), txt=rep("", 2), stringsAsFactors=FALSE)
relation.b <- data.frame(num=rep(NA, 2), txt=rep("", 2), stringsAsFactors=FALSE)

for (h in common.hcodes) {
    for (place in levels(factor(a[a$hisco == h, 'municipality']))) {
      relation.a <- rbind(relation.a, c(h, place))
    }
    for (position in levels(factor(a[a$hisco == h, 'position']))) {
      relation.a <- rbind(relation.a, c(h, position))
    }
    for (age in levels(factor(a[a$hisco == h, 'age']))) {
      relation.a <- rbind(relation.a, c(h, age))
    }
    for (gender in levels(factor(a[a$hisco == h, 'gender']))) {
      relation.a <- rbind(relation.a, c(h, gender))
    }
    for (marital in levels(factor(a[a$hisco == h, 'marital_status']))) {
      relation.a <- rbind(relation.a, c(h, marital))
    }
    
    for (place in levels(factor(b[b$hisco == h, 'municipality']))) {
      relation.b <- rbind(relation.b, c(h, place))
    }
    for (position in levels(factor(b[b$hisco == h, 'position']))) {
      relation.b <- rbind(relation.b, c(h, position))
    }
    for (age in levels(factor(b[b$hisco == h, 'age']))) {
      relation.b <- rbind(relation.b, c(h, age))
    }
    for (gender in levels(factor(b[b$hisco == h, 'gender']))) {
      relation.b <- rbind(relation.b, c(h, gender))
    }
    for (marital in levels(factor(b[b$hisco == h, 'marital_status']))) {
      relation.b <- rbind(relation.b, c(h, marital))
    }
}

relation.a <- relation.a[complete.cases(relation.a),]
relation.b <- relation.b[complete.cases(relation.b),]

# We codify the contexts more "purely" for applications like concept explorer
rel.a <- data.frame(hisco=c(), stringsAsFactors=FALSE)
rel.b <- data.frame(hisco=c(), stringsAsFactors=FALSE)

for (h in common.hcodes) {
  rel.a[h,'hisco'] <- h
  for (place in levels(factor(a[a$hisco == h, 'municipality']))) {
    rel.a[h,place] <- '1'
  }
  for (position in levels(factor(a[a$hisco == h, 'position']))) {
    rel.a[h,position] <- '1'
  }
  for (age in levels(factor(a[a$hisco == h, 'age']))) {
    rel.a[h,age] <- '1'
  }
  for (gender in levels(factor(a[a$hisco == h, 'gender']))) {
    rel.a[h,gender] <- '1'
  }
  for (marital in levels(factor(a[a$hisco == h, 'marital_status']))) {
    rel.a[h,marital] <- '1'
  }
  
  for (place in levels(factor(b[b$hisco == h, 'municipality']))) {
    rel.b[h,place] <- '1'
  }
  for (position in levels(factor(b[b$hisco == h, 'position']))) {
    rel.b[h,position] <- '1'
  }
  for (age in levels(factor(b[b$hisco == h, 'age']))) {
    rel.b[h,age] <- '1'
  }
  for (gender in levels(factor(b[b$hisco == h, 'gender']))) {
    rel.b[h,gender] <- '1'
  }
  for (marital in levels(factor(b[b$hisco == h, 'marital_status']))) {
    rel.b[h,marital] <- '1'
  }
}

rel.a[is.na(rel.a)] <- 0
rel.b[is.na(rel.b)] <- 0