#!/usr/bin/env python

# baseLiner.py: generates baseline prediction performances

import argparse
import csv
import logging
import random

class BaseLiner():
    
    def __init__(self, __logLevel, __trainFile, __evalFile):
        self.log = logging.getLogger('BaseLiner')
        self.log.setLevel(__logLevel)

        self.trainFile = __trainFile
        self.evalFile = __evalFile

        self.log.info('Initializing data structures...')
        self.trainData = {}
        self.evalData = {}

        self.log.info('Reading datasets...')
        self.readInputFiles()
        self.log.debug([self.trainData, self.evalData])
        self.log.info('Random prediction...')
        self.randomPrediction()

    def readInputFiles(self):
        with open(self.trainFile, 'rb') as csvfile:
            csvreader = csv.reader(csvfile, delimiter=',', quotechar='\"')
            next(csvreader, None)  # skip the headers
            for row in csvreader:
                self.trainData[row[0]] = row[-1]

        with open(self.evalFile, 'rb') as csvfile:
            csvreader = csv.reader(csvfile, delimiter=',', quotechar='\"')
            next(csvreader, None)  # skip the headers
            for row in csvreader:
                self.evalData[row[0]] = row[-1]

    def randomPrediction(self):
        predictions = [random.choice([0,1]) for x in self.evalData]
        print predictions
        rate = 0.
        i = 0
        for x in self.evalData.values():
            if int(x) == int(predictions[i]):
                rate += 1
            i += 1
        print rate/len(predictions)

if __name__ == "__main__":
    # Argument parsing
    parser = argparse.ArgumentParser(description="Generates baseline prediction performances")
    parser.add_argument('--verbose', '-v',
                        help = "Be verbose -- debug logging level",
                        required = False, 
                        action = 'store_true')
    parser.add_argument('--train', '-t',
                        help = "CSV files with training dataset",
                        required = True)
    parser.add_argument('--eval', '-e',
                        help = "CSV files with evaluation dataset",
                        required = True)

    args = parser.parse_args()

    # Logging
    logLevel = logging.INFO
    if args.verbose:
        logLevel = logging.DEBUG
    logging.basicConfig(level=logLevel)
    logging.info('Initializing...')

    # Instance
    baseLiner = BaseLiner(logLevel, args.train, args.eval)

    logging.info('Done.')
    
