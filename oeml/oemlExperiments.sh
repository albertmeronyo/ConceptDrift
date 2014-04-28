#!/bin/bash

# All-at-once execution of OEML experiments

EXP_DIRECTORY="./exp/"

# 1. Parameters

CHANGE_DEFS=('novelChildren' 'nonEqualChildren' 'childrenParents' 'multiClass')
IN_ALL_SNAPS=('T' 'F')

# CEDAR

CEDAR_NAME="cedar-brt"
CEDAR_INPUT_DATA="../../../cedar-brt-drift/"
CEDAR_N=8
CEDAR_TOP="http://cedar.example.org/ns#hisco"
CEDAR_SUB_PROP="http://www.w3.org/2004/02/skos/core#broader"
CEDAR_MEMB_PROP="http://cedar.example.org/ns#occupation"

# DBpedia ontology

DBO_NAME="dbpedia-ontology"
DBO_INPUT_DATA="../../../dbpedia-ontology/"
DBO_N=5
DBO_TOP="http://www.w3.org/2002/07/owl#Thing"
DBO_SUB_PROP="http://www.w3.org/2000/01/rdf-schema#subClassOf"
DBO_MEMB_PROP="http://www.w3.org/1999/02/22-rdf-syntax-ns#type"

# DBpedia categories

DBC_NAME="dbpedia-categories"
DBO_INTPU_DATA="../../../dbpedia-dump-clean/"
DBC_N=5
DBC_TOP="http://dbpedia.org/resource/Category:Contents"
DBC_SUB_PROP="http://www.w3.org/2004/02/skos/core#broader"
DBC_MEMB_PROP="http://purl.org/dc/terms/subject"


# 2. Permutations
let "END_I=$CEDAR_N-2"
echo $END_I
for i in $(seq 1 $END_I)
do
    let "END_J=$CEDAR_N-2-$END_I"
    echo $END_J
    for j in $(seq 1 $END_J)
    do
	IFS=,
	eval echo $CEDAR_NAME-$CEDAR_N-$i-$j-{"${CHANGE_DEFS[*]}"}-{"${IN_ALL_SNAPS[*]}"}
    done
done

# 2. Preparation of the directory tree

# if [ ! -d "$EXP_DIRECTORY/cedar-brt-3-1-1-NC-cp-f" ]; then
#     mkdir $EXP_DIRECTORY/cedar-brt-3-1-1-NC-cp-f;
# fi
# if [ ! -d "$EXP_DIRECTORY/cedar-brt-3-1-1-C-cp-f" ]; then
#     mkdir $EXP_DIRECTORY/cedar-brt-3-1-1-C-cp-f;
# fi
# if [ ! -d "$EXP_DIRECTORY/cedar-brt-5-1-1-NC-cp-f" ]; then
#     mkdir $EXP_DIRECTORY/cedar-brt-5-1-1-NC-cp-f;
# fi
# if [ ! -d "$EXP_DIRECTORY/cedar-brt-5-1-1-C-cp-f" ]; then
#     mkdir $EXP_DIRECTORY/cedar-brt-5-1-1-C-cp-f;
# fi



# CEDAR dataset
# ./oeml.sh ../../../cedar-brt-drift/ ./exp/cedar-brt-3-1-1-NC-cp-f/ 3 1 1 novelChildren T http://cedar.example.org/ns#hisco http://www.w3.org/2004/02/skos/core#broader http://cedar.example.org/ns#occupation &
# ./oeml.sh ../../../cedar-brt-drift/ ./exp/cedar-brt-3-1-1-C-cp-f/ 3 novelChildren F http://cedar.example.org/ns#hisco http://www.w3.org/2004/02/skos/core#broader http://cedar.example.org/ns#occupation &
# ./oeml.sh ../../../cedar-brt-drift/ ./exp/cedar-brt-5-1-1-NC-cp-f/ 5 novelChildren T http://cedar.example.org/ns#hisco http://www.w3.org/2004/02/skos/core#broader http://cedar.example.org/ns#occupation &
# ./oeml.sh ../../../cedar-brt-drift/ ./exp/cedar-brt-5-1-1-C-cp-f/ 5 novelChildren F http://cedar.example.org/ns#hisco http://www.w3.org/2004/02/skos/core#broader http://cedar.example.org/ns#occupation &

exit 0