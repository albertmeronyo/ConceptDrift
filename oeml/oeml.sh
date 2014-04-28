#!/bin/bash

DATA_DIR=$1
EXP_DIR=$2
NUM_SNAPS=$3
CHANGE=$4
IN_ALL_SNAPS=$5
TOP_CAT=$6
SUB_PROP=$7
IN_PROP=$8

python2 genFeatsP.py -i $DATA_DIR -o $EXP_DIR -n $NUM_SNAPS -c $CHANGE -t $TOP_CAT -s $SUB_PROP -m $IN_PROP -f nt 2> $EXP_DIR/error.txt > $EXP_DIR/feats_out.txt
Rscript identity-aggregator-p.R $EXP_DIR/*.csv $EXP_DIR/training.csv $IN_ALL_SNAPS 2>> $EXP_DIR/error.txt > $EXP_DIR/identity_out.txt
./weka-batch.sh $EXP_DIR/training.csv $EXP_DIR/results.txt 2>> $EXP_DIR/error.txt > $EXP_DIR/weka_out.txt
