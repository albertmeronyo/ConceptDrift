library(SPARQL)
library(gdata)

##########################
# Retrieve data via SPARQL
##########################
endpoint <- "http://lod.cedar-project.nl:8080/sparql/semstats"
options <- NULL
prefix <- c()
sparql_prefix <- "PREFIX qb: <http://purl.org/linked-data/cube#>
PREFIX imes: <http://rdf.abs.gov.au/meta/demo/measure/>
PREFIX idim: <http://rdf.abs.gov.au/meta/dimension/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"
q <- paste(sparql_prefix,"SELECT (str(?sex_l) AS ?sex_l) (str(?age_l) AS ?age_l) (str(?location_l) AS ?location_l) (str(?labour_l) AS ?labour_l) ?population
FROM <http://lod.cedar-project.nl/resource/semstats-australia>
WHERE {
 ?o a qb:Observation ;
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
PREFIX imes-demo: <http://rdf.insee.fr/meta/demo/mesure/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"

q2 <- paste(sparql_prefix2,"SELECT (str(?sex_l) AS ?sex_l) (str(?age_l) as ?age_l) (str(?location_l) AS ?location_l) (str(?labour_l) AS ?labour_l) ?population
FROM <http://lod.cedar-project.nl/resource/semstats-france>
WHERE {
 ?o a qb:Observation ;
      idim:ageq65 ?age ;
      idim:sexe ?sex ;
      idim:tactr ?labour ;
      idim-cog2012:commune ?location ;
      imes-demo:pop2010 ?population .
 ?sex skos:prefLabel ?sex_l .
 ?age skos:prefLabel ?age_l .
 ?labour skos:prefLabel ?labour_l .
 ?location skos:prefLabel ?location_l .
 FILTER(langMatches(lang(?sex_l), \"EN\"))
 FILTER(langMatches(lang(?age_l), \"EN\"))
 FILTER(langMatches(lang(?labour_l), \"EN\"))
}") 

res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results
res2 <- SPARQL(endpoint,q2,ns=prefix,extra=options)$results

#######################################################
# First experiment: extensional stability based linkage
#######################################################
# Extract all different australian locations
au.cities <- unique(res$location_l)
# Extract all different french locations
fr.cities <- unique(res2$location_l)
# Do wilcox.test for all possible pairings
 