Concept Drift on the Web
========================

Concept drift refers to the change of meaning of concepts over
time. This repo contains several experiments to detect, model and
predict change of meaning of concepts over time in the Semantic Web,
i.e. on RDF/RDFS/SKOS/OWL datasets. Most of these have been developed
in the context of the <a href='http://www.albertmeronyo.org/'
target='_blank'>autor's PhD</a>. 

Each directory contains an implementation of a different approach to
study concept drift.

## Predicting Concept Drift in Linked Data

**Directory:** `oeml`

**Associated papers:**

- Predicting Concept Drift in Linked Data (ISWC 2014, under review)

The development and maintenance of Knowledge Organization Systems
(KOS) is a knowledge intensive task that requires a lot of manual ef-
fort. Librarians, historians and social scientists need to deal with
the change of meaning of concepts (i.e. concept drift) that comes with
new data releases and novel data links. In this experiment we develop
a method to automatically detect which parts of a KOS are likely to
experience concept drift. The essential idea is to use supervised
learning on features extracted from past versions to predict the
concepts that will experience drift in a future version. We run this
method in three different experiments on datasets of different nature
(encyclopedic, cross-domain, and socio historical), named cedar-N,
dbo-N and dbo in the tasks of refining and predicting change.

For detailed results of the three experiments with the tested WEKA
classifiers, click <a
href='https://docs.google.com/spreadsheets/d/1eiqr1t5jiJQLEXFMN5-dheyurA2jpslP2WMWBIwH0O0/pubhtml'
target='_blank'>here</a>.

Dumps of the output of these experiments are available <a
href='https://github.com/albertmeronyo/ConceptDrift/tree/master/oeml/exp'
target='_blank'>here</a>.

### Pipeline detailed description

The important scripts in this approach, tentatively called OEML
(Ontology Evolution through Machine Learning) are (in execution
order):

1. `oemlExperiments.sh`: executes *all* OEML experiments (see below) of
the paper, permuting all possible (reasonable) values of the various
parameters

2. `oeml.sh`: executes *one* OEML experiment. An OEML experiment has
essentially the following parameters:

2.1. The input dataset containing the versions to train / evaluate the
classifier 
2.2. The number of versions that will be used for training 
2.3. The deltaFC parameter: what specific snapshot will be used to
decide if a concept of the training set has changed or not 
2.4. The deltaTT parameter: what specific snapshot will be used to
decide if a concept of the evaluation set has changed or not 
2.5. A boolean that indicates how to deal with concepts that do not
appear in all snapshots (essentially, consider it as changed, or
discard it). 
2.6. The URI of the top concept in the dataset 
2.7. The URI of the predicate connecting concepts (e.g. skos:broader,
or rdfs:subClassOf) 
2.8. The URI of a chosen 'membership' property (e.g. rdf:type, or
dc:subject) 

This script uses these parameters when calling the following 3
subscripts: 

3. `genFeatsP.py`: uses all the 8 parameters to generate a training
and an evaluation dataset. These datasets are two CSVs with features
that may be correlated with the fact that a concept changed between
one version of the input dataset and another, getting inspiration from
<a
href='http://www.ploscompbiol.org/article/info%3Adoi%2F10.1371%2Fjournal.pcbi.1002630'
target='_blank'>this paper</a>. Concretely, per concept read in input
dataset the following is computed:

3.1. Direct children (according to parameter 2.7)
3.2. Children at depth 2
3.3. Children at depth 3
3.4. Children at depth 4
3.5. Direct parents
3.6. Siblings
3.7. 'Members' of this concept (according to parameter 2.8)
3.8. Id. considering all children at depth 2
3.9. Id. considering all children at depth 3
3.10. Id. considering all children at depth 4
3.11. Ratio of 'members' and children of the concept
3.12. A boolean that indicates whether this concept has changed or not

This last is the target feature. To compute it, parameters 2.2, 2.3
and 2.4 are used to compare the same concept in different versions of
the input dataset. Different definitions of what is necessary to
consider a concept has changed or not are implemented; for the paper
we consider definitions of <a
href='http://link.springer.com/chapter/10.1007%2F978-3-642-16438-5_17#page-1'
target='_blank'>this paper</a>.

4. `identity-aggregator-p-R`: puts all instances together of all the
versions compared, since the previous script can only compare versions
on a 1vs1 basis. Uses the parameter 2.5 to consider only the concepts
that appear in all versions, or to consider all of them (if a concept
does not appear in one of the considered versions, it is considered as
if it has changed).

5. `weka-batch.sh`: uses the WEKA API to train all classifiers that
come with WEKA with the generated training and evaluation datasets,
and writes statistics on their performance in
`./exp/experiment-name/results.txt`

6. `oemlResults.sh`: writes results of all experiments in stdout in a
nice format.

Script 1 executes multiple instances of script 2, and each script 2
executes 3, 4 and 5. The user only needs to manually execute scripts 1
(to initiate the entire process) and 6 to visualise the results.

## Extensional Drift in Statistical Linked Data

**Directory:** `semStats` 

**Associated papers:**

- <a
href='http://www.albertmeronyo.org/wp-content/uploads/2013/08/semstats2013_submission_7-1.pdf'
target='_blank'>Detecting and Reporting Extensional Concept Drift in
Statistical Linked Data</a> (SemStats workshop, ISWC 2013)
- <a
href='http://www.albertmeronyo.org/wp-content/uploads/2013/09/semstats2013_submission_15.pdf
' target='_blank'>Non-Temporal Orderings as Proxies for Extensional
Concept Drift</a> (SemStats challenge, ISWC 2013)

Concepts are main entities in Linked Statistical Data. With new
versions and dataset releases, these concepts may change and hamper
comparability of statistical data. In this experiment we use
straightforward statistical tests to detect extensional concept drift
(which concerns the objects a concept extends to).

The directory contains R scripts to detect extensional concept drift
using paired difference tests on statistical distributions.

## Concept Drift through Formal Concept Analysis

**Directory:** `fca`

<a href='http://en.wikipedia.org/wiki/Formal_concept_analysis'
target='_blank'>Formal Concept Analysis</a> (FCA, Rudolf Wille, 1984)
is a mathematical framework to derive a concept hierarchy or ontology
from a set of objects and their properties. In these experiments FCA
is used in versioned datasets to analyse their change over time.

## Lean Ontology Matching (LeanOM)

**Directory:** `compressionSimilarity`

**Associated papers:**

- Lean Ontology Matching (unpublished)

LeanOM is a quick and straight-forward way of studying change across
versioned ontologies that come in a normalized serialization. The
basic idea is to use compression to analyze the amount of new
information, and use this as an ontology matching method.
