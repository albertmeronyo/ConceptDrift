#!/usr/bin/env python

# QBrand: generate QB with bugs

from rdflib import URIRef, Literal, Namespace, Graph
from rdflib.namespace import RDF
import random

class QBrand():
    namespaces = {
        'qb': Namespace("http://purl.org/linked-data/cube#"),
        'eg': Namespace("http://example.org/ns#"),
        'sdmx-dimension': Namespace("http://purl.org/linked-data/sdmx/2009/dimension#"),
        'sdmx-attribute': Namespace("http://purl.org/linked-data/sdmx/2009/attribute#"),
        'sdmx-code': Namespace("http://purl.org/linked-data/sdmx/2009/code#")
    }
    g = Graph()
    obsID = 0

    thisObs = None
    age = None
    agegroup = None
    height = None
    status = None
    yearsmarried = None

    def __init__(self, __healthyObs, __faultyObs, __outfile):
        """
        Class constructor
        """
        self.healthyObs = __healthyObs
        self.faultyObs = __faultyObs
        self.addHealthyObs()
        self.addFaultyObs()

        # self.printGraph()

        self.serializeGraph(__outfile)

    def addHealthyObs(self):
        """
        Add healthy observations to the graph
        """
        for obs in range(self.healthyObs):
            random.seed()
            self.thisObs = self.namespaces['eg'].thisObs + str(self.obsID)
            self.age = random.randint(0, 150)
            if self.age < 18:
                self.agegroup = self.namespaces['eg'].child
            elif self.age >= 18 and self.age < 65:
                self.agegroup = self.namespaces['eg'].adult
            else:
                self.agegroup = self.namespaces['eg'].elderly
            self.height = Literal(random.uniform(0.1, 11.0))
            if self.age < 18:
                self.status = URIRef(self.namespaces['sdmx-code'] + "status-S")
            else:
                self.status = random.choice([URIRef(self.namespaces['sdmx-code'] + "status-S"),
                                             URIRef(self.namespaces['sdmx-code'] + "status-M"),
                                             URIRef(self.namespaces['sdmx-code'] + "status-W")
                                         ])
            if self.status == URIRef(self.namespaces['sdmx-code'] + "status-M"):
                self.yearsmarried = Literal(random.randint(0, self.age - 18))  
            else:
                self.yearsmarried = Literal(0)
            self.age = Literal(self.age)

            self.addObs()  
      
            self.obsID += 1

    def addFaultyObs(self):
        """
        Add faulty observations to the graph
        """
        for obs in range(self.faultyObs):
            random.seed()
            self.thisObs = self.namespaces['eg'].thisObs + str(self.obsID)
            self.age = random.randint(0, 150)
            if self.age >= 18:
                self.agegroup = self.namespaces['eg'].child
            elif self.age < 18 and self.age >= 65:
                self.agegroup = self.namespaces['eg'].adult
            else:
                self.agegroup = self.namespaces['eg'].elderly
            self.height = Literal(random.uniform(0.1, 11.0))
            if self.age < 18:
                self.status = URIRef(self.namespaces['sdmx-code'] + "status-S")
            else:
                self.status = random.choice([URIRef(self.namespaces['sdmx-code'] + "status-S"),
                                             URIRef(self.namespaces['sdmx-code'] + "status-M"),
                                             URIRef(self.namespaces['sdmx-code'] + "status-W")
                                         ])
            if self.status == URIRef(self.namespaces['sdmx-code'] + "status-M"):
                self.yearsmarried = Literal(random.randint(0, self.age - 18))  
            else:
                self.yearsmarried = Literal(0)
            self.age = Literal(self.age)

            self.addObs()  
      
            self.obsID += 1


    def addObs(self):
        """
        Adds observation with currently set class fields
        """
        self.g.add( (self.thisObs, RDF.type, self.namespaces['qb'].Observation) )
        self.g.add( (self.thisObs, self.namespaces['qb'].dataset, URIRef(self.namespaces['eg'] + "artificial-dataset")) )
        self.g.add( (self.thisObs, self.namespaces['sdmx-dimension'].age, self.age) )
        self.g.add( (self.thisObs, self.namespaces['eg'].agegroup, self.agegroup) )
        self.g.add( (self.thisObs, self.namespaces['eg'].height, self.height) )
        self.g.add( (self.thisObs, self.namespaces['sdmx-dimension'].civilStatus, self.status) )
        self.g.add( (self.thisObs, self.namespaces['eg'].yearsMarried, self.yearsmarried) )

    def printGraph(self):
        """
        Prints current graph to stdout
        """
        for s, p, o in self.g:
            print s, p, o

    def serializeGraph(self, outfile):
        """
        Serializes current graph to outfile
        """
        self.g.serialize(outfile, format="turtle")

if __name__ == '__main__':
    qbrand = QBrand(10000, 100, "../data/test.ttl")
    exit(0)
