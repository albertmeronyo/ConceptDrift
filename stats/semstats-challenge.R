library(SPARQL)
library(gdata)
library(ggplot2)
library(gplots)
library(RColorBrewer)

##########################
# Retrieve data via SPARQL
##########################
endpoint <- "http://lod.cedar-project.nl:8080/sparql/semstats"
options <- NULL
prefix <- c()
sparql_prefix <- "PREFIX qb: <http://purl.org/linked-data/cube#>
PREFIX imes: <http://rdf.abs.gov.au/meta/demo/measure/>
PREFIX idim: <http://rdf.abs.gov.au/meta/dimension/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX census-ds:  <http://id.abs.gov.au/demo/census/2011/dataSet/>"
q <- paste(sparql_prefix,"SELECT (str(?sex_l) AS ?sex_l) (str(?age_l) AS ?age_l) (str(?location_l) AS ?location_l) (str(?labour_l) AS ?labour_l) ?population
FROM <http://lod.cedar-project.nl/resource/semstats-australia>
WHERE {
 ?o a qb:Observation ;
    qb:dataSet census-ds:STATE ;
    imes:pop2011 ?population ;
    idim:AGE5P ?age ;
    idim:ASGS ?location ;
    idim:LFSP ?labour ;
    idim:SEX ?sex .
 ?sex skos:prefLabel ?sex_l .
 ?age skos:prefLabel ?age_l .
 ?location skos:prefLabel ?location_l .
 ?labour skos:prefLabel ?labour_l .
}")

sparql_prefix2 <- "PREFIX qb: <http://purl.org/linked-data/cube#>
PREFIX idim: <http://rdf.insee.fr/meta/dimension/>
PREFIX idim-cog2012:  <http://rdf.insee.fr/meta/cog2012/dimension/>
PREFIX iatt-cog2012:  <http://rdf.insee.fr/meta/cog2012/attribut/>
PREFIX imes-demo: <http://rdf.insee.fr/meta/demo/mesure/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"

q2 <- paste(sparql_prefix2,"SELECT (str(?sex_l) AS ?sex_l) (str(?age_l) as ?age_l) (str(?location_l) AS ?location_l) (str(?labour_l) AS ?labour_l) (SUM(?population) AS ?population)
FROM <http://lod.cedar-project.nl/resource/semstats-france>
WHERE {
 ?o a qb:Observation ;
      idim:ageq65 ?age ;
      idim:sexe ?sex ;
      idim:tactr ?labour ;
      iatt-cog2012:departement ?location ;
      imes-demo:pop2010 ?population .
 ?sex skos:prefLabel ?sex_l .
 ?age skos:prefLabel ?age_l .
 ?labour skos:prefLabel ?labour_l .
 ?location skos:prefLabel ?location_l .
 FILTER(langMatches(lang(?sex_l), \"EN\"))
 FILTER(langMatches(lang(?age_l), \"EN\"))
 FILTER(langMatches(lang(?labour_l), \"EN\"))
} GROUP BY ?sex_l ?age_l ?location_l ?labour_l") 

res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results
res2 <- SPARQL(endpoint,q2,ns=prefix,extra=options)$results

# DBPedia queries
dbpedia_endpoint <- "http://dbpedia.org/sparql"
g_sparql_prefix <- "PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX : <http://dbpedia.org/resource/>
PREFIX dbpedia2: <http://dbpedia.org/property/>
PREFIX dbpedia: <http://dbpedia.org/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"
gq <- paste(g_sparql_prefix,"SELECT str(?state_l) xsd:integer(?gsp)
WHERE {
?state dbpedia2:gsppercapita ?gsp .
?state rdfs:label ?state_l .
FILTER(langMatches(lang(?state_l), \"EN\"))
}")
g2_sparql_prefix <- "PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX : <http://dbpedia.org/resource/>
PREFIX dbpedia2: <http://dbpedia.org/property/>
PREFIX dbpedia: <http://dbpedia.org/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"
gq2 <- paste(g2_sparql_prefix,"SELECT (str(?location_l) AS ?location_l) (xsd:integer(?population) AS ?population) (xsd:float(?area) AS ?area)
WHERE {
 ?location dbpedia2:subdivisionType :Regions_of_France ;
                <http://dbpedia.org/ontology/PopulatedPlace/areaTotal> ?area ;
                <http://dbpedia.org/ontology/populationTotal> ?population .
 ?location rdfs:label ?location_l .
FILTER(langMatches(lang(?location_l), \"EN\"))
}
")

gdp <- SPARQL(dbpedia_endpoint,gq,ns=prefix,extra=options)$results
gdp2 <- SPARQL(dbpedia_endpoint,gq2,ns=prefix,extra=options)$results

#############
# Pre-process
#############
# Remove other territories of Australia
res <- res[-grep('Other Territories',res$location_l),]
# Merge GDP data
a.idx <- data.frame(location_l=au.regions,idx=c(1,2,3,4,5,6,7,8))
b.idx <- data.frame(location_l=gdp$location_l, idx=c(1,3,8,7,4,6,5,2))
t <- merge(a.idx, b.idx, by='idx')
gdp.norm <- merge(gdp,t,by.x='location_l',by.y='location_l.y')
gdp.norm$location_l <- NULL
gdp.norm$idx <- NULL
colnames(gdp.norm) <- c('gsp', 'location_l')
# Generate population density
pop.norm <- data.frame(gdp2, gdp2$population/gdp2$area)
colnames(pop.norm) <- c('location_l', 'population', 'area', 'density')
bar <- data.frame(fr.regions)
pop.fr <- merge(pop.norm,bar, by.x='location_l', by.y='fr.regions')
pop.fr <- rbind(pop.fr, c('Var', pop.norm[26,2], pop.norm[26,3], pop.norm[26,4]))
pop.fr <- rbind(pop.fr,c('Nord', pop.norm[100,2], pop.norm[100,3], pop.norm[100,4]))
pop.fr <- rbind(pop.fr,c('Jura', pop.norm[93,2], pop.norm[93,3], pop.norm[93,4]))
pop.fr <- rbind(pop.fr,c('Tarn', pop.norm[70,2], pop.norm[70,3], pop.norm[70,4]))
pop.fr <- rbind(pop.fr,c('Rhône', pop.norm[65,2], pop.norm[65,3], pop.norm[65,4]))
pop.fr <- rbind(pop.fr,c('Cher', pop.norm[9,2], pop.norm[9,3], pop.norm[9,4]))
pop.fr <- rbind(pop.fr,c('Ardennes', pop.norm[31,2], pop.norm[31,3], pop.norm[31,4]))
pop.fr <- rbind(pop.fr,c('Landes', pop.norm[94,2], pop.norm[94,3], pop.norm[94,4]))
pop.fr <- rbind(pop.fr,c('Lot', pop.norm[96,2], pop.norm[96,3], pop.norm[96,4]))
pop.fr <- rbind(pop.fr,c('Paris', pop.norm[7,2], pop.norm[7,3], pop.norm[7,4]))
pop.fr$density <- as.numeric(pop.fr$density)
# Assign column data types
res$sex_l <- as.factor(res$sex_l)
res$age_l <- as.factor(res$age_l)
res$location_l <- as.factor(res$location_l)
res$labour_l <- as.factor(res$labour_l)
res$population <- as.numeric(res$population)
res2$sex_l <- as.factor(res2$sex_l)
res2$age_l <- as.factor(res2$age_l)
res2$location_l <- as.factor(res2$location_l)
res2$labour_l <- as.factor(res2$labour_l)
res2$population <- as.numeric(res2$population)

#######################################################
# First experiment: extensional stability based linkage
#######################################################
# Extract all different australian locations
au.regions <- unique(res$location_l)
# Extract all different french locations
fr.regions <- unique(res2$location_l)
# Do wilcox.test for all possible pairings
p.matrix <- matrix(c(0), nrow=length(au.regions), ncol=length(fr.regions), byrow=TRUE)
dimnames(p.matrix) <- list(au.regions, fr.regions)
for(i in au.regions) {
  for(j in fr.regions) {
    p <- wilcox.test(res[res$location_l == i,'population'],
                     res2[res2$location_l == j,'population'])
    p.matrix[i,j] <- p$p.value
  }
}
# Same experiment, young unemployment
p.matrix.yu <- matrix(c(0), nrow=length(au.regions), ncol=length(fr.regions), byrow=TRUE)
dimnames(p.matrix.yu) <- list(au.regions, fr.regions)
for(i in au.regions) {
  for(j in fr.regions) {
    p <- wilcox.test(res[res$location_l == i & (res$age_l == '15-19 years' | res$age_l == '20-24 years') & res$labour_l == 'Unemployed, Total','population'],
                     res2[res2$location_l == j & (res2$age_l == '15 to 19 years' | res2$age_l == '20 to 24 years') & res2$labour_l == 'Unemployed','population'])
    p.matrix.yu[i,j] <- p$p.value
  }
}
# Same experiment, elderly employment
p.matrix.ee <- matrix(c(0), nrow=length(au.regions), ncol=length(fr.regions), byrow=TRUE)
dimnames(p.matrix.ee) <- list(au.regions, fr.regions)
for(i in au.regions) {
  for(j in fr.regions) {
    p <- wilcox.test(res[res$location_l == i & (res$age_l == '65 + years') & res$labour_l == 'Employed, Total','population'],
                     res2[res2$location_l == j & (res2$age_l == '65 years and over') & res2$labour_l == 'Employed','population'])
    p.matrix.ee[i,j] <- p$p.value
  }
}

################################################
# Second experiment: extensional change with GDP
################################################
# Order GDP data frames
gdp.sorted <- gdp.norm[order(gdp.norm$gsp),]
# Evolution with GDP: global population
gdp.sorted$location_l <- as.character(gdp.sorted$location_l)
p.gdp <- c()
prev.location <- gdp.sorted$location_l[1]
for (i in gdp.sorted$location_l) {
  p <- wilcox.test(res[res$location_l == prev.location,'population'],
                   res[res$location_l == i,'population'])
  p.gdp <- append(p.gdp, p$p.value)
  prev.location <- i
}
# Evolution with GDP: youth unemployment
p.gdp.yu <- c()
prev.location <- gdp.sorted$location_l[1]
for (i in gdp.sorted$location_l) {
  p <- wilcox.test(res[res$location_l == prev.location & (res$age_l == '15-19 years' | res$age_l == '20-24 years') & res$labour_l == 'Unemployed, Total','population'],
                   res[res$location_l == i & (res$age_l == '15-19 years' | res$age_l == '20-24 years') & res$labour_l == 'Unemployed, Total','population'])
  p.gdp.yu <- append(p.gdp, p$p.value)
  prev.location <- i
}
# Evolution with GDP: youth unemployment, males
p.gdp.yu.m <- c()
prev.location <- gdp.sorted$location_l[1]
for (i in gdp.sorted$location_l) {
  p <- wilcox.test(res[res$sex_l == 'Male' & res$location_l == prev.location & (res$age_l == '15-19 years' | res$age_l == '20-24 years') & res$labour_l == 'Unemployed, Total','population'],
                   res[res$sex_l == 'Male' & res$location_l == i & (res$age_l == '15-19 years' | res$age_l == '20-24 years') & res$labour_l == 'Unemployed, Total','population'])
  p.gdp.yu.m <- append(p.gdp, p$p.value)
  prev.location <- i
}
# Evolution with GDP: youth unemployment, females
p.gdp.yu.f <- c()
prev.location <- gdp.sorted$location_l[1]
for (i in gdp.sorted$location_l) {
  p <- wilcox.test(res[res$sex_l == 'Female' & res$location_l == prev.location & (res$age_l == '15-19 years' | res$age_l == '20-24 years') & res$labour_l == 'Unemployed, Total','population'],
                   res[res$sex_l == 'Female' & res$location_l == i & (res$age_l == '15-19 years' | res$age_l == '20-24 years') & res$labour_l == 'Unemployed, Total','population'])
  p.gdp.yu.f <- append(p.gdp, p$p.value)
  prev.location <- i
}

# For France we use population density instead
pop.sorted <- pop.fr[order(pop.fr$density),]
# Evolution with density: youth unemployment
p.density.yu <- c()
prev.location <- pop.sorted$location_l[1]
for (i in pop.sorted$location_l) {
  p <- wilcox.test(res2[res2$location_l == prev.location & (res2$age_l == '15 to 19 years' | res2$age_l == '20 to 24 years') & res2$labour_l == 'Unemployed','population'],
                   res2[res2$location_l == i & (res2$age_l == '15 to 19 years' | res2$age_l == '20 to 24 years') & res2$labour_l == 'Unemployed','population'])
  p.density.yu <- append(p.density.yu, p$p.value)
  prev.location <- i
}

#######
# Plots
#######
myCol <- c("white", "green", "yellow", "orange", "red")
myBreaks <- c(.05, .1, .25, .5, .75, 1)
hm <- heatmap.2(p.matrix, scale="none", Rowv=NA, Colv=NA,
                col = myCol, 
                breaks = myBreaks,
                dendrogram = "none",  
                margins=c(5,5), cexRow=0.5, cexCol=1.0, key=TRUE, keysize=1.5,
                trace="none")
legend("left", fill = myCol,
       legend = c(".05 to .1", ".1 to .25", ".25 to .5", ".5 to .75", ".75 to 1"))

# GDP similarity evolution
alpha <- 0.1
p.gdp.dist <- c()
p.gdp.prev <- p.gdp.yu[1]
for(x in p.gdp.yu) {
  if (x < 0.05) {
    #dist <- p.gdp.prev - (x + alpha)
    dist <- p.gdp.prev - alpha^x
    #dist <- p.gdp.prev - alpha*x
  } else {
    dist <- p.gdp.prev
  }
  p.gdp.dist <- append(p.gdp.dist, dist)
  p.gdp.prev <- dist
}
plot(p.gdp.dist)

# Density similarity evolution
alpha <- 2
p.density.dist <- c()
p.density.prev <- p.density.yu[1]
for(x in p.density.yu) {
  if (x < 0.05) {
    #dist <- p.density.prev - (x + alpha)
    #dist <- p.density.prev - alpha^x
    dist <- p.density.prev - x
  } else {
    dist <- p.density.prev
  }
  p.density.dist <- append(p.density.dist, dist)
  p.density.prev <- dist
}
plot(p.density.dist)