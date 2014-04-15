#!/bin/bash

DATA_DIR=$1
EXP_DIR=$2
NUM_SNAPS=$3

python2 genFeatsP.py -i DATA_DIR -o EXP_DIR -n NUM_SNAPS -t http://dbpedia.org/resource/Category:Contents -s http://www.w3.org/2004/02/skos/core#broader -m http://purl.org/dc/terms/subject -f nt 2> error.txt; Rscript identity-aggregator-p.R EXP_DIR/*.csv EXP_DIR/training.csv 2>> error.txt; ./weka-batch.sh EXP_DIR/training.csv EXP_DIR/results.txt 2>> error.txt
