#!/usr/bin/env python

# LOVPrefixes.py: Retrieves and stores prefixes from
# the lov.okfn.org REST API

import urllib2
import json
import logging

class LOVPrefixes:
    prefixes = []

    def __init__(self, __config):
        '''
        Class constructor
        '''
        self.log = logging.getLogger('LOVPrefixes')

        self.config = __config
        self.LOV_LIST = self.config.get('lov', 'list')

        self.initPrefixes()

    def initPrefixes(self):
        '''
        Gets all vocabularies from lov.okfn.org
        '''
        lov_stream = urllib2.urlopen(self.LOV_LIST)
        lov_json = json.load(lov_stream)
        for r in lov_json:
            self.prefixes.append(r["prefix"])

    def getPrefixes(self):
        '''
        Returns a list of all cached LOV prefixes
        '''
        return self.prefixes





