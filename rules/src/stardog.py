#!/usr/bin/env python
from common.stardogwrapper import StardogWrapper
from common.lerharvester import LERHarvester
from common.qbharvester import QBHarvester
from ConfigParser import SafeConfigParser

CONFIG_INI = '../config.ini'

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
    lerh = LERHarvester(config)
    lerh.getRules()

    # Retrieve observations (as requested)


    # Feed Stardog instance

    
    # Launch query with SL reasoning


    # Catch and return result
    
    
    # Shutdown Stardog
    s.stopServer()

    exit(0)
