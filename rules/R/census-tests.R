library(SPARQL)
library(benford.analysis)

# prepare RDF data query
endpoint <- "http://lod.cedar-project.nl/cedar/sparql"

sparql_prefix <- 
  "prefix qb: <http://purl.org/linked-data/cube#>
prefix cedar: <http://lod.cedar-project.nl:8888/cedar/resource/>
prefix maritalstatus: <http://bit.ly/cedar-maritalstatus#>
prefix sdmx-dimension: <http://purl.org/linked-data/sdmx/2009/dimension#>
prefix sdmx-code: <http://purl.org/linked-data/sdmx/2009/code#>
prefix cedarterms: <http://bit.ly/cedar#>"

query <- paste(sparql_prefix, sprintf("SELECT * FROM <urn:graph:ler:data:aus> WHERE {
       ?obs a qb:Observation.
     ?obs <http://rdf.abs.gov.au/meta/demo/measure/pop2011> ?population .}"))
                                      
res <- SPARQL(endpoint,query)$results
summary(res)
qqnorm(res$population)

b <- benford(as.numeric(res$pop), number.of.digits = 1)
chisq(b)
plot(b)
