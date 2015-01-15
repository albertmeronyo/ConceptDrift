#!/usr/bin/bash

cd /opt/virtuoso7/bin
./isql -U dba -P $1 -S 3111 < /home/amp/src/ConceptDrift/rules/src/push-cedar-ler.sql
