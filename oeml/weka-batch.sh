#!/bin/bash

OUTPUT=$4
MEM="-Xmx18g"
WEKAPATH="-classpath weka.jar"
FEATURE_SELECTION="weka.classifiers.meta.AttributeSelectedClassifier -E \"weka.attributeSelection.ReliefFAttributeEval -M -1 -D 1 -K 10\" -S \"weka.attributeSelection.Ranker -T 0.001 -N -1\" -W"

# Conversion of last attribute to nominal, training dataset
java $WEKAPATH weka.filters.unsupervised.attribute.NumericToNominal -R last -i $1 -o $1.arff
# Removal of concept names
java $WEKAPATH weka.filters.unsupervised.attribute.Remove -R first -i $1.arff -o $1.clean.arff
# NA fileds of training as numeric
sed 's/string/numeric/g' $1.clean.arff > $1.clean.num.arff

# Id., evaluation dataset
java $WEKAPATH weka.filters.unsupervised.attribute.NumericToNominal -R last -i $2 -o $2.arff
# Removal of concept names
java $WEKAPATH weka.filters.unsupervised.attribute.Remove -R first -i $2.arff -o $2.clean.arff
# NA fields of evaluation as numeric
sed 's/string/numeric/g' $2.clean.arff > $2.clean.num.arff

INPUT="-t $1.clean.num.arff"
TEST="-T $2.clean.num.arff"
MODEL="-d $3"
USE_MODEL="-l $3"
FS="weka.classifiers.meta.AttributeSelectedClassifier"
FS_PARAMS="-E 'weka.attributeSelection.ReliefFAttributeEval -M -1 -D 1 -K 10' -S 'weka.attributeSelection.Ranker -T 0.05 -N -1' -W"
IO="$INPUT -i $MODEL"
JAVA_PREFIX="java $MEM $WEKAPATH"
JAVA_PREFIX_FS="$JAVA_PREFIX $FS $IO $FS_PARAMS"
echo "Starting WEKA-batch..."

# EXAMPLE
# java -Xmx18g -classpath weka.jar weka.classifiers.meta.AttributeSelectedClassifier -t exp/test/training.csv.clean.num.arff -i -d model.model -E "weka.attributeSelection.ReliefFAttributeEval -M -1 -D 1 -K 10" -S "weka.attributeSelection.Ranker -T 0.05 -N -1" -W weka.classifiers.bayes.BayesNet -D -- -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5

COMMANDS=( 
    "$JAVA_PREFIX_FS weka.classifiers.bayes.BayesNet -D -- -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 >> $OUTPUT" 
    "$JAVA_PREFIX weka.classifiers.bayes.BayesNet $USE_MODEL $TEST -i -p 0 >> $OUTPUT" 
    "$JAVA_PREFIX_FS weka.classifiers.bayes.NaiveBayes >> $OUTPUT" 
    "$JAVA_PREFIX weka.classifiers.bayes.NaiveBayes $USE_MODEL $TEST -i -p 0 >> $OUTPUT" 
    "$JAVA_PREFIX_FS weka.classifiers.bayes.NaiveBayesMultinomial >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.bayes.NaiveBayesMultinomial $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.bayes.NaiveBayesMultinomialUpdateable >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.bayes.NaiveBayesMultinomialUpdateable $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.bayes.NaiveBayesUpdateable >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.bayes.NaiveBayesUpdateable $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.functions.Logistic -D -- -R 1.0E-8 -M -1 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.functions.Logistic $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.functions.MultilayerPerceptron -D -- -L 0.3 -M 0.2 -N 500 -V 0 -S 0 -E 20 -H a >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.functions.MultilayerPerceptron $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.functions.SGD -D -- -F 0 -L 0.01 -R 1.0E-4 -E 500 -C 0.001 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.functions.SGD $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.functions.SimpleLogistic -D -- -I 0 -M 500 -H 50 -W 0.0 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.functions.SimpleLogistic $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.functions.SMO -D -- -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K \"weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0\" >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.functions.SMO $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.functions.VotedPerceptron -D -- -I 1 -E 1.0 -S 1 -M 10000 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.functions.VotedPerceptron $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.rules.DecisionTable -D -- -X 1 -S \"weka.attributeSelection.BestFirst -D 1 -N 5\" >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.rules.DecisionTable $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.rules.JRip -D -- -F 3 -N 2.0 -O 2 -S 1 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.rules.JRip $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.rules.OneR -D -- -B 6 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.rules.OneR $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.rules.ZeroR >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.rules.ZeroR $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.trees.DecisionStump >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.trees.DecisionStump $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.trees.HoeffdingTree -D -- -L 2 -S 1 -E 1.0E-7 -H 0.05 -M 0.01 -G 200.0 -N 0.0 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.trees.HoeffdingTree $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.trees.J48 -D -- -C 0.25 -M 2 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.trees.J48 $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.trees.RandomForest -D -- -I 10 -K 0 -S 1 -num-slots 1 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.trees.RandomForest $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.trees.RandomTree -D -- -K 0 -M 1.0 -S 1 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.trees.RandomTree $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
    "$JAVA_PREFIX_FS weka.classifiers.trees.REPTree -D -- -M 2 -V 0.001 -N 3 -S 1 -L -1 -I 0.0 >> $OUTPUT"
    "$JAVA_PREFIX weka.classifiers.trees.REPTree $USE_MODEL $TEST -i -p 0 >> $OUTPUT"
)

cat /dev/null > $OUTPUT
for comm in "${COMMANDS[@]}"
do
    echo ${comm} >> $OUTPUT
    eval ${comm}
done

echo "Done."

exit 0

# Classifier pool -- efficiency, etc

# java $MEM $WEKAPATH weka.classifiers.lazy.IBk -K 1 -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.lazy.KStar -B 20 -M a >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.lazy.LWL -U 0 -K -1 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" -W weka.classifiers.trees.DecisionStump >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.rules.PART -M 2 -C 0.25 -Q 1 >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.trees.LMT -I -1 -M 15 -W 0.0 >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.trees.RandomForest -I 50 -K 0 -S 1 -num-slots 1 >> $OUTPUT
# java $MEM $WEKAPATH weka.classifiers.trees.RandomForest -I 100 -K 0 -S 1 -num-slots 1 >> $OUTPUT
