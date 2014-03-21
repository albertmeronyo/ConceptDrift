#!/bin/bash

python2 genFeatsP.py -i ../../../dbpedia-dump-clean/ -o ./ -n 3 -t http://dbpedia.org/resource/Category:Contents -s http://www.w3.org/2004/02/skos/core#broader -m http://purl.org/dc/terms/subject -f nt ; Rscript identity-aggregator-p.R *.csv training.csv ; ./weka-batch.sh training.csv results/dbpedia-dump-clean.txt 2> error.txt
