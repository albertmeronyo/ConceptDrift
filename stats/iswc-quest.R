library(SPARQL)

##########################
# Retrieve data via SPARQL
##########################
endpoint <- "http://lod.cedar-project.nl:8897/sparql/"
options <- NULL
#prefix <- c("lop","http://semanticweb.cs.vu.nl/poseidon/ns/instances/",
#            "eez","http://semanticweb.cs.vu.nl/poseidon/ns/eez/")
prefix <- c()
sparql_prefix <- "PREFIX d2s: <http://www.data2semantics.org/core/>
                  PREFIX cd: <http://www.data2semantics.org/data/BRT_1889_08_T1_marked/Tabel_1/>
                  PREFIX ns1: <http://www.data2semantics.org/core/Tabel_1/>
                  PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"
q <- paste(sparql_prefix,"SELECT DISTINCT (str(?age_s) AS ?age_c) (str(?gender_s) AS ?gender_c) (str(?marital_status_s) AS ?marital_status_c) (str(?municipality_s) AS ?municipality_c) (str(?occ_class_s) AS ?occ_class_c) (str(?occ_subclass_s) AS ?occ_subclass_c) (str(?occupation_s) AS ?occupation_r) (REPLACE(?position_s, \"^ +| +$\", \"\") AS ?position_c) ?population
FROM <http://lod.cedar-project.nl/resource/BRT_1889_08_T1>
WHERE {
 ?cell d2s:isObservation [ d2s:dimension ?gender ;
                           d2s:dimension ?marital_status ;
                           d2s:dimension ?age ;
  		   ns1:BENAMING_van_de_onderdeelen_der_onderscheidene_beroepsklassen__met_de_daartoe_behoordende_beroepen ?occupation ;
			   ns1:Positie_in_het_beroep__aangeduid_met_A__B__C_of_D_ ?position ;
       			   d2s:populationSize ?population ] .
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
 ?position skos:prefLabel ?position_s .
 FILTER (?gender IN (cd:M, cd:V))
 FILTER (?marital_status IN (cd:O, cd:G))
 FILTER (?age IN (cd:12___1878, cd:13___1876, cd:14_---_15__1875___---_1874, cd:16_---_17__1873___---_1872, cd:1878_en_later__beneden_12_j_, cd:18_---_22__1871___---_1867, cd:Geboortejaren___leeftijd_in_j_, cd:25_---_35__1864___---_1854, cd:36_---_50__1853___---_1839, cd:51_---_60__1838___---_1829, cd:61_---_65__1828___---_1824, cd:66_---_70__1823_---_1818, cd:71_en_daarboven__1818_en_vroeger, cd:Van_onbekenden_leeftijd, cd:23_---_24__1866___---_1865))
} ORDER BY (?cell)")

res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results

#############
# Pre-process
#############
# Data.frame removing all totals
df <- data.frame(res[-grep("(Totaal|totaal)", res$occupation_r),])
# Remove all rows with NAs
df <- df[complete.cases(df),]
# Column data types
df$age_c <- as.factor(df$age_c)
df$gender_c <- as.factor(df$gender_c)
df$marital_status_c <- as.factor(df$marital_status_c)
df$municipality_c <- as.factor(df$municipality_c)
df$occ_class_c <- as.factor(df$occ_class_c)
df$occ_subclass_c <- as.factor(df$occ_subclass_c)
df$occupation_c <- as.factor(df$occupation_c)
df$position_c <- as.factor(df$position_c)
df$population <- as.numeric(df$population)

# Do variable pairings

# Calculate awesomeness between pairs