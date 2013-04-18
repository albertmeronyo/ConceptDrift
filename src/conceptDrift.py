from SPARQLWrapper import SPARQLWrapper, JSON

import pygraphviz as pgv

from pygraph.classes.graph import graph
from pygraph.classes.digraph import digraph
from pygraph.classes.exceptions import AdditionError
from pygraph.algorithms.searching import breadth_first_search
from pygraph.readwrite.dot import write

# One graph per year/ontology version
g1 = graph()

# Add nodes
sparql = SPARQLWrapper("http://kizokumaru.dyndns.org:3030/cedar/sparql")
sparql.setQuery("""
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT ?node
FROM <http://www.cedar-project.nl/data/BRT_1889_12_T1>
WHERE {
?node skos:broader ?foo
}
""")
sparql.setReturnFormat(JSON)

resultsNodesA = sparql.query().convert()

for x in resultsNodesA["results"]["bindings"]:
    try:
        g1.add_node("/".join(x["node"]["value"].split("/")[5:]))
    except AdditionError:
        pass

sparql.setQuery("""
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT ?node
FROM <http://www.cedar-project.nl/data/BRT_1889_12_T1>
WHERE {
?foo skos:broader ?node
}
""")
sparql.setReturnFormat(JSON)

resultsNodesB = sparql.query().convert()

for x in resultsNodesB["results"]["bindings"]:
    try:
        g1.add_node("/".join(x["node"]["value"].split("/")[5:]))
    except AdditionError:
        pass

#print g1

# Add edges
sparql.setQuery("""
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT ?parent ?node
FROM <http://www.cedar-project.nl/data/BRT_1889_12_T1>
WHERE {
?node skos:broader ?parent
} ORDER BY ?parent
""")

resultsEdges = sparql.query().convert()

for y in resultsEdges["results"]["bindings"]:
    g1.add_edge(("/".join(y["parent"]["value"].split("/")[5:]), "/".join(y["node"]["value"].split("/")[5:])))

# Draw as PNG
# print "Writing plot..."
dot = write(g1)
G = pgv.AGraph(dot)
G.layout(prog='dot')
G.draw('../output/foo.png')
print G.string()
# gvv = gv.readstring(dot)
# gv.layout(gvv,'dot')
# gv.render(gvv,'png','1889.png')
# print "Done."

# # Then, draw the breadth first search spanning tree rooted in Tabel_1
# st, order = breadth_first_search(g1, root="Tabel_1")
# gst = digraph()
# gst.add_spanning_tree(st)

# dot = write(gst)
# gvv = gv.readstring(dot)

# gv.layout(gvv,'dot')
# gv.render(gvv,'png','1889.png')
