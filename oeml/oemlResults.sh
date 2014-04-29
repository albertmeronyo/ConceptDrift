#!/bin/bash

# Filter OEML results from exp/*/results.txt

EXPDIR="./exp/"

for f in `ls $EXPDIR`
do
    echo 'EXPERIMENT '$f;
    cat $EXPDIR$f/results.txt | grep "Weighted\|weka\|Precision";
    printf '\n\n';
done

exit 0