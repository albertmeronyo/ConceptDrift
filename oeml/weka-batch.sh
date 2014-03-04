#!/bin/bash

INPUT="-t data/dbpedia-feats-train-arff"
OUTPUT="results.txt"
MEM="-Xmx24g"
WEKAPATH="-classpath weka.jar"

cat /dev/null > $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.ZeroR $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayes $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.J48 -C 0.25 -M 2 $INPUT -i -o >> $OUTPUT
