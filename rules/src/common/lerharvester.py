#!/usr/bin/env python
from SPARQLWrapper import SPARQLWrapper, JSON

class LERHarvester():
    def __init__(self, __config):
        '''
        Class constructor
        '''
        self.config = __config

    def getRules(self):
        '''
        Gets rules from remote SPARQL endpoint
        '''
        sparql = SPARQLWrapper(self.config.get('general', 'ler_sparql_endpoint'))
        print self.config.get('general', 'ler_query')
        sparql.setQuery(self.config.get('general', 'ler_query'))
        sparql.setReturnFormat(JSON)
        results = sparql.query().convert()
 
        for result in results["results"]["bindings"]:
            for key in result.keys():
                print result[key]["value"]
