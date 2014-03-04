from bottle import route, run, template, request, static_file
from subprocess import call, check_output
import urllib
import logging
import glob
import sys
import traceback
import os

__VERSION = 0.1

# Default server side config
datasetPath = "data/"
trainDataset = "dbpedia-feats-train"
wekaCommand = "java -classpath weka.jar"
wekaParameters = "-i -o"
classifierList = {
    "J48": "weka.classifiers.trees.J48",
    "NaiveBayes": "weka.classifiers.bayes.NaiveBayes"
}

@route('/oeml/version')
def version():
    return "OEML workbench version " + str(__VERSION)

@route('/oeml')
@route('/oeml/')
def oeml():
    return template('oeml')

@route('/oeml/dataset')
def dataset():
    datasetList = []
    for f in os.listdir(datasetPath):
        fileName, fileExtension = os.path.splitext(f)
        if fileExtension == ".arff":
            datasetList.append(fileName)
    return template('dataset', datasetList = datasetList, defaultDataset = trainDataset)

@route('/oeml/analysis')
def analysis():
    return template('analysis', classifierList = classifierList, defaultDataset = trainDataset)

@route('/oeml/analysis/run', method = "POST")
def analysis_run():
    executionList = []
    for key in classifierList:
        if request.forms.get(key):
            command = 'java -classpath weka.jar ' + classifierList[key] + ' -t ' + datasetPath + trainDataset + '.arff' + ' -i -o'
            print command
            output = check_output(command)
            print output    
    return template('oeml')
    

# Static Routes
@route('/js/<filename:re:.*\.js>')
def javascripts(filename):
    return static_file(filename, root='views/js')

@route('/css/<filename:re:.*\.css>')
def stylesheets(filename):
    return static_file(filename, root='views/css')

@route('/img/<filename:re:.*\.(jpg|png|gif|ico)>')
def images(filename):
    return static_file(filename, root='views/img')

@route('/fonts/<filename:re:.*\.(eot|ttf|woff|svg)>')
def fonts(filename):
    return static_file(filename, root='views/fonts')


run(host = 'localhost', port = 8080, debug = True)
