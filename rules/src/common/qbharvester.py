#!/usr/bin/env python
from SPARQLWrapper import SPARQLWrapper, TURTLE

class QBHarvester():
    def __init__(self, __config):
        '''
        Constructor
        '''
        self.config = __config
        self.cube = None
        self.DATA_PATH = self.config.get('io', 'data_path')
        self.QB_FILE = self.config.get('io', 'qb_file')

    def getCube(self):
        '''
        Gets cube data from remote SPARQL endpoint
        '''
        sparql = SPARQLWrapper(self.config.get('general', 'qb_sparql_endpoint'))
        sparql.setQuery(self.config.get('general', 'qb_query'))
        sparql.setReturnFormat(TURTLE)
        self.cube = sparql.query().convert()

    def serializeCube(self):
        '''
        Serializes retrieved cube data into a file for Stardog ingestion
        '''
        f = open(self.DATA_PATH + self.QB_FILE, 'w')
        f.write(self.cube)
        f.close()

