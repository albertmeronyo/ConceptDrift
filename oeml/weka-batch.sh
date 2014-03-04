#!/bin/bash

INPUT="-t data/dbpedia-feats-train.arff"
OUTPUT="results.txt"
MEM="-Xmx24g"
WEKAPATH="-classpath weka.jar"

cat /dev/null > $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.BayesNet -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayes $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayesMultinomial $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayesMultinomialUpdateable $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayesUpdateable $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.Logistic -R 1.0E-8 -M -1 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.MultilayerPerceptron -L 0.3 -M 0.2 -N 500 -V 0 -S 0 -E 20 -H a $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.SGD -F 0 -L 0.01 -R 1.0E-4 -E 500 -C 0.001 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.SimpleLogistic -I 0 -M 500 -H 50 -W 0.0 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.SMO -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0" $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.VotedPerceptron -I 1 -E 1.0 -S 1 -M 10000 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.lazy.IBk -K 1 -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.lazy.KStar -B 20 -M a $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.lazy.LWL -U 0 -K -1 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" -W weka.classifiers.trees.DecisionStump $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.DecisionTable -X 1 -S "weka.attributeSelection.BestFirst -D 1 -N 5" $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.JRip -F 3 -N 2.0 -O 2 -S 1 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.OneR -B 6 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.PART -M 2 -C 0.25 -Q 1 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.ZeroR $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.DecisionStump $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.HoeffdingTree -L 2 -S 1 -E 1.0E-7 -H 0.05 -M 0.01 -G 200.0 -N 0.0 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.J48 -C 0.25 -M 2 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.LMT -I -1 -M 15 -W 0.0 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.RandomForest -I 10 -K 0 -S 1 -num-slots 1 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.RandomForest -I 50 -K 0 -S 1 -num-slots 1 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.RandomForest -I 100 -K 0 -S 1 -num-slots 1 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.RandomForest -I 10 -K 0 -S 1 -num-slots 1 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.RandomTree -K 0 -M 1.0 -S 1 $INPUT -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.REPTree -M 2 -V 0.001 -N 3 -S 1 -L -1 -I 0.0 $INPUT -i -o >> $OUTPUT
