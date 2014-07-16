#!/usr/bin/env python

# baseLiner.py: generates baseline prediction performances

import argparse
import csv
import logging
import random

class BaseLiner():
    
    def __init__(self, __logLevel, __trainFile, __evalFile, __snapFiles):
        self.log = logging.getLogger('BaseLiner')
        self.log.setLevel(__logLevel)

        self.trainFile = __trainFile
        self.evalFile = __evalFile
        self.snapFiles = __snapFiles

        self.log.info('Initializing data structures...')
        self.trainData = {}
        self.evalData = {}
        self.snapData = []
        self.predictionRandomRate = 0.
        self.predictionPastChangedRate = 0.
        self.predictionSnapsChangedRate = 0.

        self.log.info('Reading datasets...')
        self.readInputFiles()
        # self.log.debug([self.trainData, self.evalData, self.snapData])
        self.log.info('Making predictions...')
        self.predictionRandom()
        self.log.info('Random performance is %s' % self.predictionRandomRate)
        self.predictionPastChanged()
        self.log.info('PastChanged performance is %s' % self.predictionPastChangedRate)
        self.predictionSnapsChanged()
        self.log.info('SnapsChanged performance is %s' % self.predictionSnapsChangedRate)

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

        for f in self.snapFiles:
            thisSnap = {}
            with open(f, 'rb') as csvfile:
                csvreader = csv.reader(csvfile, delimiter=',', quotechar='\"')
                next(csvreader, None)  # skip the headers
                for row in csvreader:
                    thisSnap[row[0]] = row[-1]
            self.snapData.append(thisSnap)            
        self.log.debug('Read %s snapshot files' % len(self.snapData))

    def predictionRandom(self):
        rate = 0.
        for x in self.evalData.keys():
            if int(self.evalData[x]) == int(random.choice([0,1])):
                rate += 1
        self.predictionRandomRate = rate / len(self.evalData)

    def predictionPastChanged(self):
        rate = 0.
        for x in self.evalData.keys():
            if x in self.trainData:
                if int(self.evalData[x]) == int(self.trainData[x]):
                    rate += 1
        self.predictionPastChangedRate = rate / len(self.evalData)

    def predictionSnapsChanged(self):
        rate = 0.
        zeroStrip = 0
        for x in self.evalData.keys():
            if int(self.evalData[x]) == 1:
                for d in self.snapData:
                    if x in d:
                        if int(d[x]) == 1:
                            rate += 1
                            break
            else:
                for d in self.snapData:
                    if x in d:
                        if int(d[x]) == 0:
                            zeroStrip += 1
                if zeroStrip == len(self.snapData):
                    rate += 1
        self.predictionSnapsChangedRate = rate / len(self.evalData)
                    

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
    parser.add_argument('--snaps', '-s',
                        help = "CSV files with snapshot dataset",
                        nargs='+',
                        required = True)

    args = parser.parse_args()

    # Logging
    logLevel = logging.INFO
    if args.verbose:
        logLevel = logging.DEBUG
    logging.basicConfig(level=logLevel)
    logging.info('Initializing...')

    # Instance
    baseLiner = BaseLiner(logLevel, args.train, args.eval, args.snaps[:-1])

    logging.info('Done.')
    
