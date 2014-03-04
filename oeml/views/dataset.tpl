% include('header.tpl', title='OEML workbench')

<h2>Datasets</h2>

<p>Manages all current datasets in the server. New datasets can be created, and dataset creation tasks can be monitored.<p>

<form class="form-inline" role="form">
  <div class="form-group">
    <select class="form-control input-sm" id="activeDataset">
      %for d in datasetList:
      <option {{"selected" if d == defaultDataset else ""}}>{{d}}</option>
      %end
    </select>
  </div>
  <div class="form-group">
    <button type="submit" class="btn btn-primary">Save active dataset</button>
  </div>
</form>

% include('footer.tpl')
