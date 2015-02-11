#!/usr/bin/env python

# All-at-once execution of OEML, python version

import os
from subprocess import call

# Parameters
expDir = "exp-lov/"
lovDir = "../../ConceptDrift-data/lov/"

for dirname, dirnames, filenames in os.walk(lovDir):
    for subdirname in dirnames:
        print os.path.join(dirname, subdirname)
        for x, y, versions in os.walk(os.path.join(dirname, subdirname)):
            nVersions = len(versions)
            thisExpDir = expDir + subdirname + "-" + str(nVersions) + "-1-1-allDrift-T/"
            if not os.path.exists(thisExpDir):
                os.makedirs(thisExpDir)
            call(["./oeml.sh", lovDir + subdirname + "/", thisExpDir, str(nVersions), str(1), str(1), "allDrift", "T", "http://www.w3.org/2000/01/rdf-schema#subClassOf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#type", "http://www.w3.org/2000/01/rdf-schema#label"])
