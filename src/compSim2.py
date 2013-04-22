#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import division
import os
import gzip
from SPARQLWrapper import SPARQLWrapper, JSON
import hashlib
import json
import sys

tmpDir = '../tmp/'
res = []

sparql = SPARQLWrapper("http://kizokumaru.dyndns.org:3030/cedar/sparql")
sparql.setReturnFormat(JSON)

sparql.setQuery("""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX d2s: <http://www.data2semantics.org/core/> 

SELECT DISTINCT ?value ?label
FROM <http://www.cedar-project.nl/data/1859>
WHERE {
?s a skos:Concept ;
d2s:value ?value .
?value skos:prefLabel ?label .
} ORDER BY ?value
""")

sys.stderr.write("SPARQLing for source concepts...\n")
sparqlConceptsA = sparql.query().convert()

sparql.setQuery("""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX d2s: <http://www.data2semantics.org/core/> 

SELECT DISTINCT ?value ?p ?o
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

sys.stderr.write("SPARQLing for source descriptions...\n")
sparqlDescriptionsA = sparql.query().convert()

sparql.setQuery("""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX d2s: <http://www.data2semantics.org/core/> 

SELECT DISTINCT ?value ?label
FROM <http://www.cedar-project.nl/data/1889>
WHERE {
?s a skos:Concept ;
d2s:value ?value .
?value skos:prefLabel ?label .
} ORDER BY ?value
""")

sys.stderr.write("SPARQLing for destination concepts...\n")
sparqlConceptsB = sparql.query().convert()

sparql.setQuery("""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX d2s: <http://www.data2semantics.org/core/> 

SELECT DISTINCT ?value ?p ?o
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

sys.stderr.write("SPARQLing for destination descriptions...\n")
sparqlDescriptionsB = sparql.query().convert()


totalRows = len(sparqlConceptsA["results"]["bindings"])
sys.stderr.write("Origin has {} concepts, destination has {}\n".format(len(sparqlConceptsA["results"]["bindings"]),
                                                          len(sparqlConceptsB["results"]["bindings"])))
sys.stderr.write("Computing distances...\n")
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
    sys.stderr.write("{}% done.\n".format(doneRows/totalRows*100))

for row in res:
    print row
