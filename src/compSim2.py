#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import division
import os
import gzip
from SPARQLWrapper import SPARQLWrapper, JSON
import hashlib
import json

tmpDir = '../tmp/'
res = []

sparql = SPARQLWrapper("http://kizokumaru.dyndns.org:3030/cedar/sparql")
sparql.setReturnFormat(JSON)

sparql.setQuery("""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX d2s: <http://www.data2semantics.org/core/> 

SELECT ?value ?label
FROM <http://www.cedar-project.nl/data/1859>
WHERE {
?s a skos:Concept ;
d2s:value ?value .
?value skos:prefLabel ?label .
}
""")

print "SPARQLing for source concepts..."
sparqlConceptsA = sparql.query().convert()

sparql.setQuery("""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX d2s: <http://www.data2semantics.org/core/> 

SELECT ?value ?p ?o
FROM <http://www.cedar-project.nl/data/1859>
WHERE {
?value ?p ?o .
{SELECT ?value ?label
WHERE {
?s a skos:Concept ;
d2s:value ?value .
?value skos:prefLabel ?label .
}}} ORDER BY ?value
""")

print "SPARQLing for source descriptions..."
sparqlDescriptionsA = sparql.query().convert()

sparql.setQuery("""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX d2s: <http://www.data2semantics.org/core/> 

SELECT ?value ?label
FROM <http://www.cedar-project.nl/data/1889>
WHERE {
?s a skos:Concept ;
d2s:value ?value .
?value skos:prefLabel ?label .
}
""")

print "SPARQLing for destination concepts..."
sparqlConceptsB = sparql.query().convert()

sparql.setQuery("""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX d2s: <http://www.data2semantics.org/core/> 

SELECT ?value ?p ?o
FROM <http://www.cedar-project.nl/data/1889>
WHERE {
?value ?p ?o .
{SELECT ?value ?label
WHERE {
?s a skos:Concept ;
d2s:value ?value .
?value skos:prefLabel ?label .
}}} ORDER BY ?value
""")

print "SPARQLing for destination descriptions..."
sparqlDescriptionsB = sparql.query().convert()


totalRows = len(sparqlConceptsA["results"]["bindings"])
print "Origin has {} concepts, destination has {}".format(len(sparqlConceptsA["results"]["bindings"]),
                                                          len(sparqlConceptsB["results"]["bindings"]))
print "Computing distances..."
doneRows = 0
for i in sparqlConceptsA["results"]["bindings"]:
    fi = []
    for k in sparqlDescriptionsA["results"]["bindings"]:
        if k["value"]["value"] == i["value"]["value"]:
            fi.append(k)
    fiID = hashlib.md5(i["value"]["value"]).hexdigest()
    fiComp = gzip.open(os.path.join(tmpDir, fiID + '.gz'), 'wb')
    fiComp.write(json.dumps(fi))
    fiComp.close()
    fiComp = open(os.path.join(tmpDir, fiID + '.gz'), 'r')
    fiCompSize = len(fiComp.read())
    fiComp.close()
    row = []
    for j in sparqlConceptsB["results"]["bindings"]:
        fj = []
        for k in sparqlDescriptionsB["results"]["bindings"]:
            if k["value"]["value"] == j["value"]["value"]:
                fj.append(k)
        fjID = hashlib.md5(j["value"]["value"]).hexdigest()
        fjComp = gzip.open(os.path.join(tmpDir, fjID + '.gz'), 'wb')
        fjComp.write(json.dumps(fj))
        fjComp.close()
        fjComp = open(os.path.join(tmpDir, fjID + '.gz'), 'r')
        fjCompSize = len(fjComp.read())
        fjComp.close()
        fijComp = gzip.open(os.path.join(tmpDir, fiID + fjID + '.gz'), 'wb')
        fijComp.write(json.dumps(fi))
        fijComp.write(json.dumps(fj))
        fijComp.close()
        fijComp = open(os.path.join(tmpDir, fiID + fjID + '.gz'), 'r')
        fijCompSize = len(fijComp.read())
        fijComp.close()
        row.append(max((fijCompSize - fjCompSize)/fiCompSize, (fijCompSize - fiCompSize)/fjCompSize))
    res.append(row)
    doneRows += 1
    print "{}% done.".format(doneRows/totalRows*100)

for row in res:
    print row
