#!/bin/bash

OUTPUT=$4
MEM="-Xmx18g"
WEKAPATH="-classpath weka.jar"

# Conversion of last attribute to nominal, training dataset
java $WEKAPATH weka.filters.unsupervised.attribute.NumericToNominal -R last -i $1 -o $1.arff

# NA fileds of training as numeric
sed 's/string/numeric/g' $1.arff > $1.num.arff

# Id., evaluation dataset
java $WEKAPATH weka.filters.unsupervised.attribute.NumericToNominal -R last -i $2 -o $2.arff

# NA fields of evaluation as numeric
sed 's/string/numeric/g' $2.arff > $2.num.arff

INPUT="-t $1.num.arff"
TEST="-T $2.num.arff"
MODEL="-d $3"
USE_MODEL="-l $3"

echo "Starting WEKA-batch..."

cat /dev/null > $OUTPUT
echo "Starting BayesNet..."
echo "weka.classifiers.bayes.BayesNet -i -o -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.BayesNet $INPUT $MODEL -i -o -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.BayesNet $USE_MODEL $TEST -i >> $OUTPUT
echo "BayesNet completed."
echo "Starting NaiveBayes..."
echo "weka.classifiers.bayes.NaiveBayes -i -o" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayes $INPUT $MODEL -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayes $USE_MODEL $TEST -i >> $OUTPUT
echo "NaiveBayes completed."
echo "Starting NaiveBayesMultinomial..."
echo "weka.classifiers.bayes.NaiveBayesMultinomial -i -o" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayesMultinomial $INPUT $MODEL -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayesMultinomial $USE_MODEL $TEST -i >> $OUTPUT
echo "NaiveBayesMultinomial completed."
echo "Starting NaiveBayesMultinomialUpdateable..."
echo "weka.classifiers.bayes.NaiveBayesMultinomialUpdateable -i -o" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayesMultinomialUpdateable $INPUT $MODEL -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayesMultinomialUpdateable $USE_MODEL $TEST -i >> $OUTPUT
echo "NaiveBayesMultinomialUpdateable completed."
echo "Starting NaiveBayesUpdateable..."
echo "weka.classifiers.bayes.NaiveBayesUpdateable -i -o" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayesUpdateable $INPUT $MODEL -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.bayes.NaiveBayesUpdateable $USE_MODEL $TEST -i >> $OUTPUT
echo "NaiveBayesUpdateable completed."
echo "Starting Logistic..."
echo "weka.classifiers.functions.Logistic -i -o -R 1.0E-8 -M -1" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.Logistic $INPUT $MODEL -i -o -R 1.0E-8 -M -1 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.Logistic $USE_MODEL $TEST -i >> $OUTPUT
echo "Logistic completed."
echo "Starting MultilayerPerceptron..."
echo "weka.classifiers.functions.MultilayerPerceptron -i -o -L 0.3 -M 0.2 -N 500 -V 0 -S 0 -E 20 -H a" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.MultilayerPerceptron $INPUT $MODEL -i -o -L 0.3 -M 0.2 -N 500 -V 0 -S 0 -E 20 -H a >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.MultilayerPerceptron $USE_MODEL $TEST -i >> $OUTPUT
echo "MultilayerPerceptron completed."
echo "Starting SGD..."
echo "weka.classifiers.functions.SGD -i -o -F 0 -L 0.01 -R 1.0E-4 -E 500 -C 0.001" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.SGD $INPUT $MODEL -i -o -F 0 -L 0.01 -R 1.0E-4 -E 500 -C 0.001 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.SGD $USE_MODEL $TEST -i >> $OUTPUT
echo "SGD completed."
echo "Starting SimpleLogistic..."
echo "weka.classifiers.functions.SimpleLogistic -i -o -I 0 -M 500 -H 50 -W 0.0" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.SimpleLogistic $INPUT $MODEL -i -o -I 0 -M 500 -H 50 -W 0.0 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.SimpleLogistic $USE_MODEL $TEST -i >> $OUTPUT
echo "SimpleLogistic completed."
echo "Starting SMO..."
echo "weka.classifiers.functions.SMO -i -o -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K \"weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0\"" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.SMO $INPUT $MODEL -i -o -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.SMO $USE_MODEL $TEST -i >> $OUTPUT
echo "SMO completed."
echo "Starting VotedPerceptron..."
echo "weka.classifiers.functions.VotedPerceptron -i -o -I 1 -E 1.0 -S 1 -M 10000" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.VotedPerceptron $INPUT $MODEL -i -o -I 1 -E 1.0 -S 1 -M 10000 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.functions.VotedPerceptron $USE_MODEL $TEST -i >> $OUTPUT
echo "VotedPerceptron completed."
# echo "Starting IBk..."
# echo "weka.classifiers.lazy.IBk -i -o -K 1 -W 0 -A \"weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"\"" >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.lazy.IBk $INPUT $MODEL -i -o -K 1 -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" >> $OUTPUT
# echo "IBk completed."
# echo "Starting KStar..."
# echo "weka.classifiers.lazy.KStar -i -o -B 20 -M a" >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.lazy.KStar $INPUT $MODEL -i -o -B 20 -M a >> $OUTPUT
# echo "KStar completed."
# echo "Starting LWL..."
# echo "weka.classifiers.lazy.LWL -i -o -U 0 -K -1 -A \"weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"\" -W weka.classifiers.trees.DecisionStump" >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.lazy.LWL $INPUT $MODEL -i -o -U 0 -K -1 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" -W weka.classifiers.trees.DecisionStump >> $OUTPUT
# echo "LWL completed."
echo "Starting DecisionTable..."
echo "weka.classifiers.rules.DecisionTable -i -o -X 1 -S \"weka.attributeSelection.BestFirst -D 1 -N 5\"" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.DecisionTable $INPUT $MODEL -i -o -X 1 -S "weka.attributeSelection.BestFirst -D 1 -N 5" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.DecisionTable $USE_MODEL $TEST -i >> $OUTPUT
echo "DecisionTable completed."
echo "Starting JRip..."
echo "weka.classifiers.rules.JRip -i -o -F 3 -N 2.0 -O 2 -S 1" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.JRip $INPUT $MODEL -i -o -F 3 -N 2.0 -O 2 -S 1 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.JRip $USE_MODEL $TEST -i >> $OUTPUT
echo "JRip completed."
echo "Starting OneR..."
echo "weka.classifiers.rules.OneR -i -o -B 6" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.OneR $INPUT $MODEL -i -o -B 6 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.OneR $USE_MODEL $TEST -i >> $OUTPUT
echo "OneR completed."
# echo "Starting PART..."
# echo "weka.classifiers.rules.PART -i -o -M 2 -C 0.25 -Q 1" >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.rules.PART $INPUT $MODEL -i -o -M 2 -C 0.25 -Q 1 >> $OUTPUT
# echo "PART completed."
echo "Starting ZeroR..."
echo "weka.classifiers.rules.ZeroR -i -o" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.ZeroR $INPUT $MODEL -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.rules.ZeroR $USE_MODEL $TEST -i >> $OUTPUT
echo "ZeroR completed."
echo "Starting DecisionStump..."
echo "weka.classifiers.trees.DecisionStump -i -o" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.DecisionStump $INPUT $MODEL -i -o >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.DecisionStump $USE_MODEL $TEST -i >> $OUTPUT
echo "DecisionStump completed."
echo "Starting HoeffdingTree..."
echo "weka.classifiers.trees.HoeffdingTree -i -o -L 2 -S 1 -E 1.0E-7 -H 0.05 -M 0.01 -G 200.0 -N 0.0" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.HoeffdingTree $INPUT $MODEL -i -o -L 2 -S 1 -E 1.0E-7 -H 0.05 -M 0.01 -G 200.0 -N 0.0 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.HoeffdingTree $USE_MODEL $TEST -i >> $OUTPUT
echo "HoeffdingTree completed."
echo "Starting J48..."
echo "weka.classifiers.trees.J48 -i -o -C 0.25 -M 2" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.J48 $INPUT $MODEL -i -o -C 0.25 -M 2 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.J48 $USE_MODEL $TEST -i >> $OUTPUT
echo "J48 completed."
# echo "Starting LMT..."
# echo "weka.classifiers.trees.LMT -i -o -I -1 -M 15 -W 0.0" >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.trees.LMT $INPUT $MODEL -i -o -I -1 -M 15 -W 0.0 >> $OUTPUT
# echo "LMT completed."
echo "Starting RandomForest..."
echo "weka.classifiers.trees.RandomForest -i -o -I 10 -K 0 -S 1 -num-slots 1" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.RandomForest $INPUT $MODEL -i -o -I 10 -K 0 -S 1 -num-slots 1 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.RandomForest $USE_MODEL $TEST -i >> $OUTPUT
echo "RandomForest completed."
# echo "Starting RandomForest with 50 trees..."
# echo "weka.classifiers.trees.RandomForest -i -o -I 50 -K 0 -S 1 -num-slots 1" >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.trees.RandomForest $INPUT $MODEL -i -o -I 50 -K 0 -S 1 -num-slots 1 >> $OUTPUT
# echo "RandomForest with 50 trees completed."
# echo "Starting RandomForest with 100 trees..."
# echo "weka.classifiers.trees.RandomForest -i -o -I 100 -K 0 -S 1 -num-slots 1" >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.trees.RandomForest $INPUT $MODEL -i -o -I 100 -K 0 -S 1 -num-slots 1 >> $OUTPUT
# echo "RandomForest with 100 trees completed."
echo "Starting RandomTrees..."
echo "weka.classifiers.trees.RandomTree -i -o -K 0 -M 1.0 -S 1" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.RandomTree $INPUT $MODEL -i -o -K 0 -M 1.0 -S 1 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.RandomTree $USE_MODEL $TEST -i >> $OUTPUT
echo "RandomTree completed."
echo "Starting REPTree..."
echo "weka.classifiers.trees.REPTree -i -o -M 2 -V 0.001 -N 3 -S 1 -L -1 -I 0.0" >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.REPTree $INPUT $MODEL -i -o -M 2 -V 0.001 -N 3 -S 1 -L -1 -I 0.0 >> $OUTPUT
java $MEM $WEKAPATH weka.classifiers.trees.REPTree $USE_MODEL $TEST -i >> $OUTPUT
echo "REPTree completed."

echo "All done."

exit 0
