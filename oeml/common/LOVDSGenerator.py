#!/usr/bin/env python

# LOVDSGenerator.py: Generates versioned datasets out of
# retrieved LOV verioned vocabularies

import urllib2
import json
import logging

class LOVDSGenerator:
    jDump = None

    def __init__(self, __config):
        '''
        Class constructor
        '''
        self.log = logging.getLogger('LOVDSGenerator')

        self.config = __config

        self.LOV_FILE = self.config.get('general', 'dump_file')

        self.initDumpFile()
        self.generateDatasets()

    def initDumpFile(self):
        '''
        Opens dump file
        '''
        f = open(self.LOV_FILE, 'r')
        self.jDump = json.load(f)

    def generateDatasets(self):
        '''
        Generates datasets out of URIs in config.ini's dump_file
        '''
        for voc, vers in self.jDump.iteritems():
            for ver in sorted(vers, key=lambda v: v[0]):
                print ver[0].split(':')[0].split('T')[0] + '-' + voc + '.nt'
