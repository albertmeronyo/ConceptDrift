#!/bin/bash

HOME_STARDOG="/Users/Albert/src/stardog-2.2.3/bin"
DB_NAME="people"
A_BOX="/Users/Albert/src/ConceptDrift/rules/people.ttl"
R_BOX="/Users/Albert/src/ConceptDrift/rules/people-rules.ttl"

PATH=$PATH:$HOME_STARDOG

# Backend server
# stardog-admin server start

# Populate knowledge base
stardog-admin db drop $DB_NAME
stardog-admin db create -n $DB_NAME $A_BOX $R_BOX

# Querying
# ./stardog query "people" "select ?s ?o where {?s <http://example.org/ns#edits> ?o}"

# With SL inference! :-)
# ./stardog query "people;reasoning=SL" "select ?s ?o where {?s <http://example.org/ns#edits> ?o}"
# ./stardog query "people;reasoning=SL" "select ?s ?p ?o where {?s ?p ?o . filter(?o = true || ?o = false)} order by ?s ?p" > ../../ConceptDrift/rules/stardog-sl-out.txt

# Providing explanations
# ./stardog reasoning explain -r SL people "eg:o1 a eg:foo"
