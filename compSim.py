import os
import gzip

dataDir = './data'
tmpDir = './tmp'
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
        row.append(fijCompSize - fiCompSize)
    res.append(row)

print res
