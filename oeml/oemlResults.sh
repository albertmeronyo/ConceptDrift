#!/bin/bash

# Filter OEML results from exp/*/results.txt

EXPDIR=$1

for f in `ls $EXPDIR`
do
    echo 'EXPERIMENT '$f;
    cat $EXPDIR$f/results.txt | grep "Weighted\|weka";
    printf '\n\n';
done

exit 0
