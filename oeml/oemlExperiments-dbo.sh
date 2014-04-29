#!/bin/bash

# All-at-once execution of OEML experiments

EXP_DIRECTORY="./exp/"

# 1. Parameters

# DBpedia ontology

NAME="dbpedia-ontology"
INPUT_DATA="../../../dbpedia-ontology/"
N=5
TOP="http://www.w3.org/2002/07/owl#Thing"
SUB_PROP="http://www.w3.org/2000/01/rdf-schema#subClassOf"
MEMB_PROP="http://www.w3.org/1999/02/22-rdf-syntax-ns#type"

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