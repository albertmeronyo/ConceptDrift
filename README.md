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

For detailed results of the three experiments with the tested WEKA
classifiers, click <a
href='https://docs.google.com/spreadsheets/d/1eiqr1t5jiJQLEXFMN5-dheyurA2jpslP2WMWBIwH0O0/pubhtml'
target='_blank'>here</a>. 

## Extensional Drift in Statistical Linked Data

Directory: `semStats`

Concepts are main entities in Linked Statistical Data. With new
versions and dataset releases, these concepts may change and hamper
comparability of statistical data. In this experiment we use
straightforward statistical tests to detect extensional concept drift
(which concerns the objects a concept extends to).

## Concept Drift through Formal Concept Analysis

Directory: `fca`

<a href='http://en.wikipedia.org/wiki/Formal_concept_analysis'
target='_blank'>Formal Concept Analysis</a> (FCA, Rudolf Wille, 1984)
is a mathematical framework to derive a concept hierarchy or ontology
from a set of objects and their properties. In these experiments FCA
is used in versioned datasets to analyse their change over time.

## Lean Ontology Matching (LeanOM)

Directory: `compressionSimilarity`

LeanOM is a quick and straight-forward way of studying change across
versioned ontologies that come in a normalized serialization. The
basic idea is to use compression to analyze the amount of new
information, and use this as an ontology matching method.


* `fca` contains few experiments with the Formal Concept Analysis
(FCA) framework of Rudolf Wille
* `semStats` contains R scripts to detect extensional concept drift
  using paired difference tests on statistical distributions
  

