SPARQL CLEAR GRAPH <urn:graph:ler:data:people>;
DELETE FROM load_list WHERE ll_graph = 'urn:graph:ler:data:people';
ld_dir('/home/amp/src/ConceptDrift/rules/data', 'people.ttl', 'urn:graph:ler:data:people');
rdf_loader_run();
checkpoint;
DB.DBA.RDF_GRAPH_USER_PERMS_SET ('urn:graph:ler:data:people', 'nobody', 1);

