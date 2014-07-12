#!/bin/bash

# All-at-once execution of OEML experiments

EXP_DIRECTORY="./exp/"

# 1. Parameters

CHANGE_DEFS=(allDrift)
IN_ALL_SNAPS=(T)

# CEDAR

NAME="cedar-brt"
INPUT_DATA="../../../cedar-brt-drift/"
N=8
TOP="http://cedar.example.org/ns#hisco"
SUB_PROP="http://www.w3.org/2004/02/skos/core#broader"
MEMB_PROP="http://cedar.example.org/ns#occupation"
LABEL_PROP="http://www.w3.org/2004/02/skos/core#prefLabel"

# 2. Permutations

# let "END_I=$N-1"
# for i in $(seq 1 $END_I)
# do
#     let "END_J=$N-1-$i"
#     for j in $(seq 1 $END_J)
#     do
#         # echo $NAME-$N-$i-$j-{'novelChildren','nonEqualChildren','childrenParents','multiClass'}-{'T','F'}
# 	mkdir $EXP_DIRECTORY/$NAME-$N-$i-$j-{'novelChildren','nonEqualChildren','childrenParents','multiClass'}-{'T','F'} 2> /dev/null
# 	echo -e "./oeml.sh "$INPUT_DATA" "$EXP_DIRECTORY$NAME-$N-$i-$j-{'novelChildren','nonEqualChildren','childrenParents','multiClass'}-{'T','F'}/" "$N" "$i" "$j" "{'novelChildren','nonEqualChildren','childrenParents','multiClass'}" "{'T','F'}" "$TOP" "$SUB_PROP" "$MEMB_PROP";"
#     done
# done

# for CD in "${CHANGE_DEFS[@]}"
# do
#     for IAS in "${IN_ALL_SNAPS[@]}"
#     do
# 	mkdir $EXP_DIRECTORY$NAME-$N-1-1-$CD-$IAS/ 2> /dev/null
# 	./oeml.sh $INPUT_DATA $EXP_DIRECTORY$NAME-$N-1-1-$CD-$IAS/ $N 1 1 $CD $IAS $TOP $SUB_PROP $MEMB_PROP $LABEL_PROP
#     done
# done

for n in $(seq 1 8)
do
    mkdir $EXP_DIRECTORY$NAME-$n-1-1-allDrift-T/ 2> /dev/null
    rm -rf $EXP_DIRECTORY$NAME-$n-1-1-allDrift-T/* 2> /dev/null
    ./oeml.sh ../../../cedar-brt-drift/ $EXP_DIRECTORY$NAME-$n-1-1-allDrift-T/ $n 1 1 allDrift T http://cedar.example.org/ns#hisco http://www.w3.org/2004/02/skos/core#broader http://cedar.example.org/ns#occupation http://www.w3.org/2004/02/skos/core#prefLabel
done

exit 0
