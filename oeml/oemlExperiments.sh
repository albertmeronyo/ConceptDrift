#!/bin/bash

# All-at-once execution of OEML experiments

EXP_DIRECTORY="./exp/"

# Directory tree

if [ ! -d "$EXP_DIRECTORY/cedar-brt-3-1-1-NC-cp-f" ]; then
    mkdir $EXP_DIRECTORY/cedar-brt-3-1-1-NC-cp-f;
fi
if [ ! -d "$EXP_DIRECTORY/cedar-brt-3-1-1-C-cp-f" ]; then
    mkdir $EXP_DIRECTORY/cedar-brt-3-1-1-C-cp-f;
fi
if [ ! -d "$EXP_DIRECTORY/cedar-brt-5-1-1-NC-cp-f" ]; then
    mkdir $EXP_DIRECTORY/cedar-brt-5-1-1-NC-cp-f;
fi
if [ ! -d "$EXP_DIRECTORY/cedar-brt-5-1-1-C-cp-f" ]; then
    mkdir $EXP_DIRECTORY/cedar-brt-5-1-1-C-cp-f;
fi



# CEDAR dataset
./oeml.sh ../../../cedar-brt-drift/ ./exp/cedar-brt-3-1-1-NC-cp-f/ 3 T http://cedar.example.org/ns#hisco http://www.w3.org/2004/02/skos/core#broader http://cedar.example.org/ns#occupation &
./oeml.sh ../../../cedar-brt-drift/ ./exp/cedar-brt-3-1-1-C-cp-f/ 3 F http://cedar.example.org/ns#hisco http://www.w3.org/2004/02/skos/core#broader http://cedar.example.org/ns#occupation &
./oeml.sh ../../../cedar-brt-drift/ ./exp/cedar-brt-5-1-1-NC-cp-f/ 5 T http://cedar.example.org/ns#hisco http://www.w3.org/2004/02/skos/core#broader http://cedar.example.org/ns#occupation &
./oeml.sh ../../../cedar-brt-drift/ ./exp/cedar-brt-5-1-1-C-cp-f/ 5 F http://cedar.example.org/ns#hisco http://www.w3.org/2004/02/skos/core#broader http://cedar.example.org/ns#occupation &
