from rdflib import Graph
from rdflib.namespace import URIRef, SKOS
import sys
import csv
import gc

sys.setrecursionlimit(30000)

def recSKOS(g, h, n):
    if (None, SKOS.broader, n) not in g:
        return True
    else: 
        if n not in h:
            h[n] = []
        for s, p, o in g.triples( (None, SKOS.broader, n) ):
            if s not in h[n]:
                h[n].append(s)
                recSKOS(g, h, s)

def countChildren(h, n, r):
    if n not in h:
        return 0
    else:
        if r > 0:
            childCounts = []
            for child in h[n]:
                childCounts.append(countChildren(h, child, r - 1))
            return len(h[n]) + sum(childCounts)
        else:
            return len(h[n])

def countSiblings(g, n):
    siblings = []
    for s, p, o in g.triples( (n, SKOS.broader, None) ):
        for s2, p2, o2 in g.triples( (None, SKOS.broader, o) ):
            siblings.append([s2, p2, o2])
    return len(siblings)

def countArticles(g, n, dcsubject = URIRef("http://purl.org/dc/terms/subject")):
    # How many articles have n as subject category
    arts = []
    for s, p, o in g.triples( (None, dcsubject, n) ):
        arts.append(s)
    return len(arts)


g = Graph()
g.parse("../dbpedia-dump/3.8/skos_categories_en.nt", format="nt")
h = Graph()
h.parse("../dbpedia-dump/3.8/article_categories_en.nt", format="nt")

tree = {}
top = URIRef("http://dbpedia.org/resource/Category:Contents")

recSKOS(g, tree, top)

datasets = ['3.5.1', '3.6', '3.7']

for ds in datasets:
    # Load sources
    g_o = Graph()
    h_o = Graph()
    g_o.parse("../dbpedia-dump/" + ds + "/skos_categories_en.nt", format="nt")
    h_o.parse("../dbpedia-dump/" + ds + "/article_categories_en.nt", format="nt")
    
    # Compute tree
    tree_o = {}
    recSKOS(g_o, tree_o, top)

    # Write stats on THIS tree, compare last attribute with 3.8 tree
    with open('feats_' + ds + '.csv', 'wb') as csvfile:
        writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for key in tree_o:
            writer.writerow([ key.encode('utf-8'), 
                              countChildren(tree_o, key, 0), 
                              countChildren(tree_o, key, 1), 
                              countChildren(tree_o, key, 2),
                              countChildren(tree_o, key, 3),
                              countSiblings(g_o, key),
                              countArticles(h_o, key),
                              1 if key in tree and countChildren(tree, key, 0) > countChildren(tree_o, key, 0) else 0 ])

    # Clean
    g_o = None
    h_o = None
    gc.collect()


# Load sources                                                                                                                                       
g_o = Graph()
h_o = Graph()
g_o.parse("../dbpedia-dump/3.9/skos_categories_en.nt", format="nt")
h_o.parse("../dbpedia-dump/3.9/article_categories_en.nt", format="nt")

# Compute tree                                                                                                                                       
tree_o = {}
recSKOS(g_o, tree_o, top)

# Write stats on THIS tree, compare last attribute with 3.8 tree                                                                                     
with open('feats_3.9.csv', 'wb') as csvfile:
    writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for key in tree:
        writer.writerow([ key.encode('utf-8'),
                          countChildren(tree, key, 0),
                          countChildren(tree, key, 1),
                          countChildren(tree, key, 2),
                          countChildren(tree, key, 3),
                          countSiblings(g, key),
                          countArticles(h, key),
                          1 if key in tree_o and countChildren(tree_o, key, 0) > countChildren(tree, key, 0) else 0 ])

# Clean                                                                                                                                              
g_o = None
h_o = None
gc.collect()

