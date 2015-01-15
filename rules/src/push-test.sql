SPARQL CLEAR GRAPH <urn:graph:ler:data:test>;
DELETE FROM load_list WHERE ll_graph = 'urn:graph:ler:data:test';
ld_dir('/home/amp/src/ConceptDrift/rules/data', 'test.ttl', 'urn:graph:ler:data:test');
rdf_loader_run();
checkpoint;
DB.DBA.RDF_GRAPH_USER_PERMS_SET ('urn:graph:ler:data:test', 'nobody', 1);

