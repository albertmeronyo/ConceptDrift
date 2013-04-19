#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import division
import os
import gzip

dataDir = '../data/ecgo-sum'
tmpDir = '../tmp'
res = []

sparql = SPARQLWrapper("http://kizokumaru.dyndns.org:3030/sparql")
sparql.setQuery("""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX d2s: <http://www.data2semantics.org/core/> 

SELECT ?label
FROM <http://www.cedar-project.nl/data/1859>
WHERE {
?s a skos:Concept ;
d2s:value ?value .
?value skos:prefLabel ?label .
}
""")

sparql.setReturnFormat(JSON)
sparqlResults = sparql.query().convert()

for i in sorted(os.listdir(dataDir)):
    fi = open(os.path.join(dataDir, i), 'r')
    fiComp = gzip.open(os.path.join(tmpDir, i + '.gz'), 'wb')
    fiComp.writelines(fi)
    fiComp.close()
    fi.close()
    fiComp = open(os.path.join(tmpDir, i + '.gz'), 'r')
    fiCompSize = len(fiComp.read())
    fiComp.close()
    row = []
    for j in sorted(os.listdir(dataDir)):
        if i == j:
            row.append('x')
            continue
        fj = open(os.path.join(dataDir, j), 'r')
        fjComp = gzip.open(os.path.join(tmpDir, j + '.gz'), 'wb')
        fjComp.writelines(fj)
        fjComp.close()
        fj.close()
        fjComp = open(os.path.join(tmpDir, j + '.gz'), 'r')
        fjCompSize = len(fjComp.read())
        fjComp.close()
        fi = open(os.path.join(dataDir, i), 'r')
        fj = open(os.path.join(dataDir, j), 'r')
        fijComp = gzip.open(os.path.join(tmpDir, i + j + '.gz'), 'wb')
        fijComp.write(fi.read())
        fijComp.write(fj.read())
        fijComp.close()
        fi.close()
        fj.close()
        fijComp = open(os.path.join(tmpDir, i + j + '.gz'), 'r')
        fijCompSize = len(fijComp.read())
        fijComp.close()
        row.append(max((fijCompSize - fjCompSize)/fiCompSize, (fijCompSize - fiCompSize)/fjCompSize))
    res.append(row)

print sorted(os.listdir(dataDir))
for row in res:
    print row
