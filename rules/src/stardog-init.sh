#!/bin/bash

if [ $# -eq 0 ] 
	then
	echo "No arguments supplied"
	exit 1
fi

HOME_STARDOG="/Users/Albert/src/stardog-2.2.3/bin"
DB_NAME="people"
A_BOX="/Users/Albert/src/ConceptDrift/rules/people.ttl"
R_BOX="/Users/Albert/src/ConceptDrift/rules/people-rules.ttl"

PATH=$PATH:$HOME_STARDOG

# Backend server
cd $HOME_STARDOG
stardog-admin server stop
if [ -a $HOME_STARDOG/system.lock ]
	then
	rm $HOME_STARDOG/system.lock
fi
stardog-admin server start

# Populate knowledge base
stardog-admin db drop $DB_NAME
stardog-admin db create -n $DB_NAME $A_BOX $R_BOX
