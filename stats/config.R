# Data sources
endpoint <- 'http://lod.cedar-project.nl:8080/sparql/cedar'
a.graph <- 'http://lod.cedar-project.nl/resource/BRT_1889_08_T1'
b.graph <- 'http://lod.cedar-project.nl/resource/BRT_1899_04_T'

# Prefixes
prefixes <- "PREFIX d2s: <http://www.data2semantics.org/core/>
             PREFIX cda: <http://www.data2semantics.org/data/BRT_1889_08_T1_marked/Tabel_1/>
             PREFIX ns1a: <http://www.data2semantics.org/core/Tabel_1/>
             PREFIX cdb: <http://www.data2semantics.org/data/BRT_1899_04_T_marked/Noordholland/>
             PREFIX ns1b: <http://www.data2semantics.org/core/Noordholland/>
             PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"

# Predicate of the numeric variable in A
a.numeric.predicate <- 'd2s:populationSize'

# Name of the other variables, their predicates, and their
# allowed values in A
# First, variable names. These are arbitrary names
a.variables.names <- c('gender',
                       'marital_stauts',
                       'age',
                       'occupation')
# Second, variable predicates. These are the predicates that correspond
# to the declared object variables of previous step
a.variables.predicates <- c('d2s:dimension',
                            'd2s:dimension',
                            'd2s:dimension',
                            'ns1a:BENAMING_van_de_onderdeelen_der_onderscheidene_beroepsklassen__met_de_daartoe_behoordende_beroepen')
# Third, variable values. These are the values the previously declared
# variables are restricted to (if no restriction applies, leave an empty array)
a.variables.values <- c(
                        c('cda:M',
                          'cda:V'),
                        c('cda:O',
                          'cda:G'),
                        c('cda:12___1878',
                          'cda:13___1876',
                          'cda:14_---_15__1875___---_1874',
                          'cda:16_---_17__1873___---_1872',
                          'cda:1878_en_later__beneden_12_j_',
                          'cda:18_---_22__1871___---_1867',
                          'cda:Geboortejaren___leeftijd_in_j_',
                          'cda:25_---_35__1864___---_1854',
                          'cda:36_---_50__1853___---_1839',
                          'cda:51_---_60__1838___---_1829',
                          'cda:61_---_65__1828___---_1824',
                          'cda:66_---_70__1823_---_1818',
                          'cda:71_en_daarboven__1818_en_vroeger',
                          'cda:Van_onbekenden_leeftijd',
                          'cda:23_---_24__1866___---_1865'),
                        c()    
                     )

# Predicate of the numeric variable in B
b.numeric.predicate <- 'd2s:populationSize'

# Name of the other variables, their predicates, and their
# allowed values in B
# First, variable names. These are arbitrary names
b.variables.names <- c('gender',
                       'marital_stauts',
                       'age',
                       'occupation')
# Second, variable predicates. These are the predicates that correspond
# to the declared object variables of previous step
b.variables.predicates <- c('d2s:dimension',
                            'd2s:dimension',
                            'd2s:dimension',
                            'ns1b:Benaming_van_de_onderdeelen_der_onderscheidene_beroepsklassen__met_de_daartoe_behoorende_beroepen')
# Third, variable values. These are the values the previously declared
# variables are restricted to (if no restriction applies, leave an empty array)
b.variables.values <- c(
                        c('cdb:MANNEN',
                          'cdb:VROUWEN'),
                        c('cdb:O_',
                          'cdb:G_'),
                        c('cdb:12_of_13_1887_-_1886',
                          'cdb:14_of_15_1885_-_1884',
                          'cdb:16_of_17_1883_-_1882',
                          'cdb:18_-_22_1881_-_1877',
                          'cdb:23_-_35_1876_-_1864',
                          'cdb:beneden_12_jaar_1888_en_later',
                          'cdb:51_-_60_1848_-_1839',
                          'cdb:61_-_65_1838_-_1834',
                          'cdb:66_-_70_1833_-_1829',
                          'cdb:71_en_daarboven_1828_en_vroeger',
                          'cdb:36_-_50_1863_-_1849'),
                        c()
                     )
