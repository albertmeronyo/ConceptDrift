#!/usr/bin/env python

# LOVVersions.py: Retrieves and stores vocab versions from
# the lov.okfn.org REST API

import urllib2
import json
import logging
from LOVPrefixes import LOVPrefixes

class LOVVersions:
    versions = {}

    def __init__(self, __config):
        '''
        Class constructor
        '''
        self.log = logging.getLogger('LOVVersions')

        self.config = __config
        self.LOV_DETAIL = self.config.get('lov', 'detail')

        self.pref = LOVPrefixes(self.config)

        self.initVersions()

    def initVersions(self):
        '''
        Gets all vocabulary versions from lov.okfn.org
        '''
        for vocab in self.pref.getPrefixes():
            lov_stream = urllib2.urlopen(self.LOV_DETAIL + vocab)
            lov_json = json.load(lov_stream)
            if "versions" in lov_json.keys():
                self.versions[vocab] = []
                for ver in lov_json["versions"]:
                    self.versions[vocab].append( (ver["issued"], ver["fileURL"]) )

    def getVersions(self):
        '''
        Returns a dict of all cached LOV vocab versions (key = vocab,
        value = list of ( date issued, version URI ) )
        '''
        return self.versions

    def serializeVersions(self):
        '''
        Serializes retrieved versions in a json file
        '''
        with open(self.config.get('general', 'dump_file'), 'wb') as fp:
            json.dump(self.getVersions(), fp)
                





