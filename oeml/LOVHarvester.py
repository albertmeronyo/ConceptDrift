#!/usr/bin/env python

# lovHarvester.py: A Linked Data vocabulary version harvester using
# the lov.okfn.org REST API

import urllib2
import json
import argparse
import logging

class LOVHarvester():
    LOV_LIST = "http://lov.okfn.org/dataset/lov/api/v2/vocabulary/list"
    LOV_DETAIL = "http://lov.okfn.org/dataset/lov/api/v2/vocabulary/info?vocab="

    def __init__(self, __logLevel):
        '''
        Class constructor
        '''
        self.log = logging.getLogger('LOVHarvester')
        self.log.setLevel(__logLevel)

        self.log.info("Initializing data structures...")
        self.prefixes = []

        self.log.info("Getting prefixes...")
        self.getPrefixes()

        self.log.info("All done.")

    def getPrefixes(self):
        '''
        Gets all vocabularies from lov.okfn.org
        '''
        lov_stream = urllib2.urlopen(self.LOV_LIST)
        lov_json = json.load(lov_stream)
        for r in lov_json:
            self.prefixes.append(r["prefix"])

if __name__ == "__main__":
    # Argument parsing
    parser = argparse.ArgumentParser(description="Retrieves versions of Linked Open Vocabularies from lov.okfn.org")
    parser.add_argument('--verbose', '-v',
                        help = "Be verbose -- debug logging level",
                        required = False, 
                        action = 'store_true')
    args = parser.parse_args()

    # Logging
    logLevel = logging.INFO
    if args.verbose:
        logLevel = logging.DEBUG
    logging.basicConfig(level=logLevel)
    logging.info("Initializing...")

    # Instance
    l = LOVHarvester(logLevel)
    logging.info("Exiting...")
    exit(0)
