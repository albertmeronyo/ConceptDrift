library(SPARQL)
library(benford.analysis)

###################
# 1. Data retrieval
###################
# We retrieve observations from an endpoint that contains RDF Data Cube data

# query parameters
gender <- "F"
year <- 1971
census <- "VT"

# prepare RDF data query
endpoint <- "http://lod.cedar-project.nl/cedar/sparql"

sparql_prefix <- 
  "prefix qb: <http://purl.org/linked-data/cube#>
prefix cedar: <http://lod.cedar-project.nl:8888/cedar/resource/>
prefix maritalstatus: <http://bit.ly/cedar-maritalstatus#>
prefix sdmx-dimension: <http://purl.org/linked-data/sdmx/2009/dimension#>
prefix sdmx-code: <http://purl.org/linked-data/sdmx/2009/code#>
prefix cedarterms: <http://bit.ly/cedar#>"

query <- paste(sparql_prefix, sprintf("select * from <urn:graph:cedar:release> where {
  ?obs a qb:Observation.
  ?obs cedarterms:population ?pop.
  ?obs sdmx-dimension:sex sdmx-code:sex-%s .
  ?obs sdmx-dimension:refArea ?muni .
  ?slice a qb:Slice.
  ?slice qb:observation ?obs.
  ?slice sdmx-dimension:refPeriod \"%s\"^^xsd:integer .
  ?slice cedarterms:censusType \"%s\" .
} limit 1000", gender, year, census))

res <- SPARQL(endpoint,query)$results
pop <- res$pop
plot(density(pop))