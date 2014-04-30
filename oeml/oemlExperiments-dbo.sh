#!/bin/bash

# All-at-once execution of OEML experiments

EXP_DIRECTORY="./exp/"

# 1. Parameters

CHANGE_DEFS=(oneDrift allDrift)
IN_ALL_SNAPS=(T)

# DBpedia ontology

NAME="dbpedia-ontology"
INPUT_DATA="../../../dbpedia-ontology/"
N=5
TOP="http://www.w3.org/2002/07/owl#Thing"
SUB_PROP="http://www.w3.org/2000/01/rdf-schema#subClassOf"
MEMB_PROP="http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
LABEL_PROP="http://www.w3.org/2000/01/rdf-schema#label"

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

for CD in "${CHANGE_DEFS[@]}"
do
    for IAS in "${IN_ALL_SNAPS[@]}"
    do
	mkdir $EXP_DIRECTORY$NAME-$N-1-1-$CD-$IAS/ 2> /dev/null
	./oeml.sh $INPUT_DATA $EXP_DIRECTORY$NAME-$N-1-1-$CD-$IAS/ $N 1 1 $CD $IAS $TOP $SUB_PROP $MEMB_PROP $LABEL_PROP
    done
done

exit 0