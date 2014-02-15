library(SPARQL)

########################################
# Querying data from 1849, 1859 and 1889
########################################

endpoint <- "http://lod.cedar-project.nl:8080/sparql/cedar"
options <- NULL
prefix <- c()
sparql_prefix <- "PREFIX d2s: <http://lod.cedar-project.nl/core/>
PREFIX ns1: <http://lod.cedar-project.nl/core/DERDE_GEDEELTE/>
PREFIX cd: <http://lod.cedar-project.nl/resource/VT_1849_07_H3/DERDE_GEDEELTE/>"
q <- paste(sparql_prefix,"SELECT DISTINCT (str(?gender_s) AS ?gender_c) (str(?age_s) AS ?age_c) (str(?occupation_s) AS ?occupation_c) (str(?place_s) AS ?place_c) ?population
FROM <http://lod.cedar-project.nl/resource/VT_1849_07_H3>
WHERE {
?cell d2s:isObservation [ d2s:dimension ?gender ;
      d2s:dimension ?age ;
      ns1:Beroepen_of_middelen_van_bestaan ?occupation ;
      ns1:Gebied ?place ;
      d2s:populationSize ?population ] .

      ?gender skos:prefLabel ?gender_s .
      ?age skos:prefLabel ?age_s .
      ?occupation skos:prefLabel ?occupation_s .
      ?place skos:prefLabel ?place_s .

      FILTER (?gender IN (cd:Mannelijk, cd:Vrouwelijk))
      FILTER (?age IN (cd:Beneden_de_10_jaren, cd:Van_10_en_11_jaren, cd:Van_12_tot_en_met_15_jaren, cd:Van_16_jaren_en_daarboven))
}")

sparql_prefix2 <- "PREFIX d2s: <http://www.data2semantics.org/core/>
PREFIX ns3: <http://www.data2semantics.org/core/het_Rijk/>
PREFIX cd: <http://www.data2semantics.org/data/VT_1859_02_H2_marked/het_Rijk/>"
q2 <- paste(sparql_prefix2,"SELECT DISTINCT (str(?gender_s) AS ?gender_c) (str(?factual_s) AS ?factual_c) (str(?age_s) AS ?age_c) (str(?occupation_s) AS ?occupation_c) (str(?class_s) AS ?class_c) ?population
FROM <http://lod.cedar-project.nl/resource/VT_1859_02_H2>
WHERE {
?cell d2s:isObservation [ d2s:dimension ?gender ;
      d2s:dimension ?factual ;
      d2s:dimension ?age ;
      ns3:BEROEPEN_OF_MIDDELEN_VAN_BESTAAN ?occupation ;
      ns3:BEROEPSKLASSEN ?class ;
      d2s:populationSize ?population ] .

      ?gender skos:prefLabel ?gender_s .
      ?factual skos:prefLabel ?factual_s .
      ?age skos:prefLabel ?age_s .
      ?occupation skos:prefLabel ?occupation_s .
      ?class skos:prefLabel ?class_s .

      FILTER (?gender IN (cd:M_, cd:V_))
      FILTER (?factual IN (cd:Werkelijke_bevolking, cd:Feitelijke_bevolking))
      FILTER (?age IN (cd:PERSONEN_BENEDEN_DE__10_JAREN_GEBOREN_IN_1859-1850, cd:PERSONEN_VAN_10_EN_11_JAREN_GEBOREN_IN_1849-1848, cd:PERSONEN_VAN_12_EN_16_JAREN_GEBOREN_IN_1847-1844, cd:PERSONEN_VAN_16_EN_23_JAREN_GEBOREN_IN_1843-1837, cd:PERSONEN_VAN_23_JAREN_EN_DAARBOVEN_GEBOREN_IN_1836_EN_VROEGERE_JAREN))
}")

sparql_prefix3 <- "PREFIX d2s: <http://www.data2semantics.org/core/>
PREFIX cd: <http://www.data2semantics.org/data/BRT_1889_02_T1_marked/Table_1/>
PREFIX ns1: <http://www.data2semantics.org/core/Table_1/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"
q3 <- paste(sparql_prefix3,"SELECT DISTINCT (str(?age_s) AS ?age_c) (str(?gender_s) AS ?gender_c) (str(?marital_status_s) AS ?marital_status_c) (str(?occupation_s) AS ?occupation_c) (REPLACE(?position_s, \"^ +| +$\", \"\") AS ?position_c) ?population
FROM <http://lod.cedar-project.nl/resource/BRT_1889_02_T1>
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
           
           ?cell d2s:cell ?cell_s .
           ?age skos:prefLabel ?age_s .
           ?gender skos:prefLabel ?gender_s .
           ?marital_status skos:prefLabel ?marital_status_s .
           ?occupation skos:prefLabel ?occupation_s .
           
           FILTER (?gender IN (cd:M, cd:V))
           FILTER (?marital_status IN (cd:O, cd:G))
           FILTER (?age IN (cd:12___1878, cd:13___1876, cd:14_---_15__1875___---_1874, cd:16_---_17__1873___---_1872, cd:1878_en_later__beneden_12_j_, cd:18_---_22__1871___---_1867, cd:25_---_35__1864___---_1854, cd:36_---_50__1853___---_1839, cd:51_---_60__1838___---_1829, cd:61_---_65__1828___---_1824, cd:66_---_70__1823_---_1818, cd:71_en_daarboven__1818_en_vroeger, cd:23_---_24__1866___---_1865))
           } ORDER BY (?cell)")


res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results
res2 <- SPARQL(endpoint,q2,ns=prefix,extra=options)$results
res3 <- SPARQL(endpoint,q3,ns=prefix,extra=options)$results

#############
# Pre-process
#############

df49 <- res
df59 <- res2
df89 <- res3
# Remove all rows with NAs
# df49 <- df49[complete.cases(df49),]
# df59 <- df59[complete.cases(df59),]
# df89 <- df89[complete.cases(df89),]
# Remove possibly duplicated rows
df49 <- df49[!duplicated(df49),]
df59 <- df59[!duplicated(df59),]
df89 <- df89[!duplicated(df89),]
# Assign column data types
df49$gender_c <- as.factor(df49$gender_c)
df49$age_c <- as.factor(df49$age_c)
df49$occupation_c <- as.factor(df49$occupation_c)
df49$place_c <- as.factor(df49$place_c)
df49$population <- as.numeric(df49$population)
df59$gender_c <- as.factor(df59$gender_c)
df59$factual_c <- as.factor(df59$factual_c)
df59$age_c <- as.factor(df59$age_c)
df59$occupation_c <- as.factor(df59$occupation_c)
df59$class_c <- as.factor(df59$class_c)
df59$population <- as.numeric(df59$population)
df89$age_c <- as.factor(df89$age_c)
df89$gender_c <- as.factor(df89$gender_c)
df89$marital_status_c <- as.factor(df89$marital_status_c)
df89$occupation_c <- as.factor(df89$occupation_c)
df89$occupation <- as.factor(df89$occupation)
df89$position_c <- as.factor(df89$position_c)
df89$population <- as.numeric(df89$population)
# Remove partial totals
df49 <- df49[-grep("TOTAAL", df49$occupation_c),]
df59 <- df59[-grep("TOTAAL", df59$occupation_c),]
df89 <- df89[-grep("(Totaal|totaal)", df89$occupation_c),]

###############
# Harmonization
###############

# The common variables are: age, gender, occupation, population

# 1849: gender, age, occupation, place, population
# We get only totals for place, and get rid of the column
df49 <- subset(df49, df49$place_c %in% c('DE STEDEN EN HET PLATTE LAND VEREENIGD.'))
df49$place_c <- factor(df49$place_c)
df49$place_c <- NULL

# 1859: gender, factual, age, occupation, class, population
# We simply remove class, and aggregate everything except factual to get rid of it
df59$class_c <- NULL
df59 <- aggregate(df59$population, list(df59$gender_c, df59$age_c, df59$occupation_c), FUN = sum)
colnames(df59) <- c('gender_c', 'age_c', 'occupation_c', 'population')

# 1889: age, gender, marital status, occupation, position, population
# Likewise, aggregation to get rid of marital and position
df89 <- aggregate(df89$population, list(df89$age_c, df89$gender_c, df89$occupation), FUN = sum)
colnames(df89) <- c('age_c', 'gender_c', 'occupation_c', 'population')

# Names
levels(df49$gender_c) <- c('Male', 'Female')
levels(df49$age_c) <- c('Younger than 10', '10 to 11', '12 to 15', 'Older than 16')
levels(df59$gender_c) <- c('Male', 'Female')
levels(df59$age_c) <- c('Younger than 10', '10 to 11', '12 to 15', '16 to 23 years', 'Older than 23')
levels(df89$gender_c) <- c('Male', 'Female')
levels(df89$age_c) <- c('12', '13', '14 to 15', '16 to 17', '18 to 22', 'Younger than 12', '23 to 24', '25 to 35', '36 to 50', '51 to 60', '61 to 65', '66 to 70', 'Older than 70')

####################
# Aggregation levels
####################

# Age is the tricky one
# 1. We omit it
df49_noage <- aggregate(df49$population, list(df49$gender, df49$occupation), FUN = sum)
colnames(df49_noage) <- c('gender', 'occupation', 'population')
df59_noage <- aggregate(df59$population, list(df59$gender, df59$occupation), FUN = sum)
colnames(df59_noage) <- c('gender', 'occupation', 'population')
df89_noage <- aggregate(df89$population, list(df89$gender, df89$occupation), FUN = sum)
colnames(df89_noage) <- c('gender', 'occupation', 'population')

# 2. We aggregate age categories at the common baseline level 


# 3. We aggregate everything
df49_all <- aggregate(df49$population, list(df49$occupation), FUN = sum)
colnames(df49_all) <- c('occupation', 'population')
df59_all <- aggregate(df59$population, list(df59$occupation), FUN = sum)
colnames(df59_all) <- c('occupation', 'population')
df89_all <- aggregate(df89$population, list(df89$occupation), FUN = sum)
colnames(df89_all) <- c('occupation', 'population')