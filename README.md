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

Directory: `oeml`

Associated papers:

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

Dumps of the output of these experiments are available here.

## Extensional Drift in Statistical Linked Data

Directory: `semStats` 

Associated papers: 

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

Directory: `fca`

<a href='http://en.wikipedia.org/wiki/Formal_concept_analysis'
target='_blank'>Formal Concept Analysis</a> (FCA, Rudolf Wille, 1984)
is a mathematical framework to derive a concept hierarchy or ontology
from a set of objects and their properties. In these experiments FCA
is used in versioned datasets to analyse their change over time.

## Lean Ontology Matching (LeanOM)

Directory: `compressionSimilarity`

Associated papers:

- Lean Ontology Matching (unpublished)

LeanOM is a quick and straight-forward way of studying change across
versioned ontologies that come in a normalized serialization. The
basic idea is to use compression to analyze the amount of new
information, and use this as an ontology matching method.
