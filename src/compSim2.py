#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import division
import os
import gzip
from SPARQLWrapper import SPARQLWrapper, JSON
import hashlib

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
sparqlResultsA = sparql.query().convert()

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
sparqlResultsB = sparql.query().convert()

print "Computing distances..."
for i in sparqlResultsA["results"]["bindings"]:
    query = """
            SELECT ?p ?o
            FROM <http://www.cedar-project.nl/data/1889>
            WHERE {
              <""" + i["value"]["value"] +  """> ?p ?o .
            }
            """
    sparql.setQuery(query)
    fi = sparql.query().convert()
    fiID = hashlib.md5(i["value"]["value"]).hexdigest()
    fiComp = gzip.open(os.path.join(tmpDir, fiID + '.gz'), 'wb')
    fiComp.writelines(fi)
    fiComp.close()
    fiComp = open(os.path.join(tmpDir, fiID + '.gz'), 'r')
    fiCompSize = len(fiComp.read())
    fiComp.close()
    row = []
    for j in sparqlResultsB["results"]["bindings"]:
        query = """
                SELECT ?p ?o
                FROM <http://www.cedar-project.nl/data/1889>
                WHERE {
                <""" + i["value"]["value"] +  """> ?p ?o .
                }
                """
        sparql.setQuery(query)
        fj = sparql.query().convert()
        fjID = hashlib.md5(j["value"]["value"]).hexdigest()
        fjComp = gzip.open(os.path.join(tmpDir, fjID + '.gz'), 'wb')
        fjComp.writelines(fj)
        fjComp.close()
        fjComp = open(os.path.join(tmpDir, fjID + '.gz'), 'r')
        fjCompSize = len(fjComp.read())
        fjComp.close()
        fijComp = gzip.open(os.path.join(tmpDir, fiID + fjID + '.gz'), 'wb')
        fijComp.writelines(fi)
        fijComp.writelines(fj)
        fijComp.close()
        fijComp = open(os.path.join(tmpDir, fiID + fjID + '.gz'), 'r')
        fijCompSize = len(fijComp.read())
        fijComp.close()
        row.append(max((fijCompSize - fjCompSize)/fiCompSize, (fijCompSize - fiCompSize)/fjCompSize))
    res.append(row)

for row in res:
    print row
