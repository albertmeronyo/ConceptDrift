SPARQL CLEAR GRAPH <urn:graph:ler:rules:people>;
DELETE FROM load_list WHERE ll_graph = 'urn:graph:ler:rules:people';
ld_dir('/home/amp/src/ConceptDrift/rules/data', 'people-rules.ttl', 'urn:graph:ler:rules:people');
rdf_loader_run();
checkpoint;
DB.DBA.RDF_GRAPH_USER_PERMS_SET ('urn:graph:ler:rules:people', 'nobody', 1);

