#!/usr/bin/env python
from common.stardogwrapper import StardogWrapper
from ConfigParser import SafeConfigParser

CONFIG_INI = '../config.ini'

DB_NAME="people"
A_BOX="/Users/Albert/src/ConceptDrift/rules/people.ttl"
R_BOX="/Users/Albert/src/ConceptDrift/rules/people-rules.ttl"

if __name__ == '__main__':
    # Read config file
    config = SafeConfigParser()
    config.read(CONFIG_INI)
    
    # Initialize Stardog instance
    s = StardogWrapper(config)
    s.restartServer()

    # Retrive rules (as requested)


    # Retrieve observations (as requested)

    
