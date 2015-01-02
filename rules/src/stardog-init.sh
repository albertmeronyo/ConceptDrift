#!/bin/bash

HOME_STARDOG="/Users/Albert/src/stardog-2.2.3/bin"
DB_NAME="people"
A_BOX="/Users/Albert/src/ConceptDrift/rules/people.ttl"
R_BOX="/Users/Albert/src/ConceptDrift/rules/people-rules.ttl"

PATH=$PATH:$HOME_STARDOG

# Backend server
stardog-admin server start
