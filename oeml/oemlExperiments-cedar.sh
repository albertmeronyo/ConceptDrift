#!/bin/bash

# All-at-once execution of OEML experiments

EXP_DIRECTORY="./exp/"

# 1. Parameters

# CEDAR

NAME="cedar-brt"
INPUT_DATA="../../../cedar-brt-drift/"
N=8
TOP="http://cedar.example.org/ns#hisco"
SUB_PROP="http://www.w3.org/2004/02/skos/core#broader"
MEMB_PROP="http://cedar.example.org/ns#occupation"

# 2. Permutations

# let "END_I=$N-1"
let "END_I=1"
for i in $(seq 1 $END_I)
do
    # let "END_J=$N-1-$i"
    let "END_J=1"
    for j in $(seq 1 $END_J)
    do
        # echo $NAME-$N-$i-$j-{'novelChildren','nonEqualChildren','childrenParents','multiClass'}-{'T','F'}
	mkdir $EXP_DIRECTORY/$NAME-$N-$i-$j-{'novelChildren','nonEqualChildren','childrenParents','multiClass'}-{'T','F'} 2> /dev/null
	eval echo -e "./oeml.sh "$INPUT_DATA" "$EXP_DIRECTORY$NAME-$N-$i-$j-{'novelChildren','nonEqualChildren','childrenParents','multiClass'}-{'T','F'}/" "$N" "$i" "$j" "{'novelChildren','nonEqualChildren','childrenParents','multiClass'}" "{'T','F'}" "$TOP" "$SUB_PROP" "$MEMB_PROP
    done
done

exit 0