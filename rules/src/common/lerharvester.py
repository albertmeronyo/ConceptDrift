#!/usr/bin/env python
from SPARQLWrapper import SPARQLWrapper, TURTLE
import os

class LERHarvester():
    def __init__(self, __config):
        '''
        Class constructor
        '''
        self.config = __config
        self.rules = None
        self.DATA_PATH = self.config.get('io', 'data_path')
        self.RULE_FILE = self.config.get('io', 'rule_file')

    def getRules(self):
        '''
        Gets rules from remote SPARQL endpoint
        '''
        sparql = SPARQLWrapper(self.config.get('general', 'ler_sparql_endpoint'))
        sparql.setQuery(self.config.get('general', 'ler_query'))
        sparql.setReturnFormat(TURTLE)
        self.rules = sparql.query().convert()

    def serializeRules(self):
        '''
        Serializes retrieved rules into a file for Stardog ingestion
        '''
        f = open(self.DATA_PATH + self.RULE_FILE, 'w')
        f.write(self.rules)
        f.close()
