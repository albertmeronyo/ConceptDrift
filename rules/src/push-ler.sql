DB.DBA.USER_CREATE ('ler', sprintf('%d',rnd(1e16)));
GRANT SPARQL_SELECT to "ler";
DB.DBA.RDF_DEFAULT_USER_PERMS_SET ('ler', 0);
DB.DBA.RDF_GRAPH_USER_PERMS_SET ('urn:graph:ler:rules:people', 'ler', 1);

SPARQL CLEAR GRAPH <urn:graph:ler:rules:people>;
ld_dir('/home/amp/src/ConceptDrift/rules/data', 'people-rules.ttl', 'urn:graph:ler:rules:people');
rdf_loader_run();
checkpoint;
