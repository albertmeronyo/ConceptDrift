#!/usr/bin/env python

# lovHarvester.py: A Linked Data vocabulary version harvester using
# the lov.okfn.org REST API

import urllib2
import json

class LOVHarvester():
    LOV_LIST = "http://lov.okfn.org/dataset/lov/api/v2/vocabulary/list"
    LOV_DETAIL = "http://lov.okfn.org/dataset/lov/api/v2/vocabulary/info?vocab="

    def __init__(self):
        '''
        Class constructor
        '''
        self.prefixes = []

        self.getPrefixes()

    def getPrefixes(self):
        '''
        Gets all vocabularies from lov.okfn.org
        '''
        lov_stream = urllib2.urlopen(self.LOV_LIST)
        lov_json = json.load(lov_stream)
        for r in lov_json:
            self.prefixes.append(r["prefix"])

if __name__ == "__main__":
    l = LOVHarvester()
    exit(0)
