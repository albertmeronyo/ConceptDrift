#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import division
import os
import gzip

dataDir = '../data'
tmpDir = '../tmp'
res = []

for i in os.listdir(dataDir):
    fi = open(os.path.join(dataDir, i), 'r')
    fiComp = gzip.open(os.path.join(tmpDir, i + '.gz'), 'wb')
    fiComp.writelines(fi)
    fiComp.close()
    fi.close()
    fiComp = open(os.path.join(tmpDir, i + '.gz'), 'r')
    fiCompSize = len(fiComp.read())
    fiComp.close()
    row = []
    for j in os.listdir(dataDir):
        if i == j:
            row.append('x')
            continue
        fj = open(os.path.join(dataDir, j), 'r')
        fjComp = gzip.open(os.path.join(tmpDir, j + '.gz'), 'wb')
        fjComp.writelines(fj)
        fjComp.close()
        fj.close()
        fjComp = open(os.path.join(tmpDir, j + '.gz'), 'r')
        fjCompSize = len(fjComp.read())
        fjComp.close()
        fi = open(os.path.join(dataDir, i), 'r')
        fj = open(os.path.join(dataDir, j), 'r')
        fijComp = gzip.open(os.path.join(tmpDir, i + j + '.gz'), 'wb')
        fijComp.write(fi.read())
        fijComp.write(fj.read())
        fijComp.close()
        fi.close()
        fj.close()
        fijComp = open(os.path.join(tmpDir, i + j + '.gz'), 'r')
        fijCompSize = len(fijComp.read())
        fijComp.close()
        row.append(max((fijCompSize - fjCompSize)/fiCompSize, (fijCompSize - fiCompSize)/fjCompSize))
    res.append(row)

for row in res:
    print row
