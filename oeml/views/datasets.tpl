% include('header.tpl', title='OEML workbench')

<h2>Datasets</h2>

<p>Manages all current datasets in the server. New datasets can be created, and dataset creation tasks can be monitored.<p>

<ul>
%for d in datasetList:
<li>{{d}}
%end
</ul>
    
% include('footer.tpl')
