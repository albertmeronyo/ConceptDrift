SPARQL CLEAR GRAPH <urn:graph:ler:rules:cedar>;
DELETE FROM load_list WHERE ll_graph = 'urn:graph:ler:rules:cedar';
ld_dir('/home/amp/src/ConceptDrift/rules/data', 'cedar-rules.ttl', 'urn:graph:ler:rules:cedar');
rdf_loader_run();
checkpoint;
DB.DBA.RDF_GRAPH_USER_PERMS_SET ('urn:graph:ler:rules:cedar', 'nobody', 1);

