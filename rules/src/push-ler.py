#!/usr/bin/env python

from common.push import Pusher
from ConfigParser import SafeConfigParser
import logging

class RulePusher():
    def __init__(self, configFileName):
        self.config = SafeConfigParser()
        self.config.read(configFileName)

        logLevel = logging.DEBUG if self.config.get("debug", "verbose") else logging.INFO
        logging.basicConfig(level=logLevel)
        self.log = logging.getLogger("RulePusher")
        self.log.setLevel(logLevel)
        self.log.info("Initializing...")
        
        self.log.info("Pushing rules...")
        self.push_rules()

    def push_rules(self):
        endpoint = self.config.get("general", "sparql_endpoint")
        rule_file = self.config.get("general", "rule_file")
        try:
            self.log.info("Pushing file %s to %s..." % (rule_file, endpoint))
            pusher = Pusher(endpoint)
            pusher.upload_file(rule_file)
        except:
            self.log.error("Upload failed!")
        self.log.info("Done.")

if __name__ == '__main__':
    rule_pusher = RulePusher("../config.ini")

    


