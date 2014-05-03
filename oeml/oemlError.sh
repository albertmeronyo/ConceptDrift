#!/bin/bash

# Filter OEML errors from exp/*/error.txt

EXPDIR="./exp/"

for f in `ls $EXPDIR`
do
    echo 'EXPERIMENT '$f
    cat $EXPDIR$f/error.txt 
    printf '\n\n';
done

exit 0
