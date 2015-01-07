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
# ./stardog query "people;reasoning=SL" "select ?s ?p ?o where {?s ?p ?o . filter(?p in (eg:num1, eg:num2, eg:num3, eg:num4, eg:cat5, eg:mix6, eg:mix7, eg:mix8, eg:mix9))} order by ?s ?p" > ../../ConceptDrift/rules/stardog-sl-out.txt
# ../../ConceptDrift/rules/stardog.sh ; ./stardog query "people;reasoning=SL" "select ?s ?p ?o where {?s ?p ?o . filter(?p = eg:violates)} order by ?s ?p" > ../../ConceptDrift/rules/stardog-sl-out.txt

# Providing explanations
# ./stardog reasoning explain -r SL people "eg:o1 a eg:foo"

# Macro-edits
# ./stardog query people "prefix stardog: <tag:stardog:api:> prefix eg: <http://example.org/ns#> select ?foo where { bind(stardog:R(\"wilcox.test\", eg:slice1, eg:slice2, eg:height) as ?foo)}"
