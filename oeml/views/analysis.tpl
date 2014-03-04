% include('header.tpl', title='OEML workbench')

<h2>Analysis</h2>

<p>Executes selected Machine Learning classifiers.<p>

<form class="form-inline" role="form" action="/oeml/analysis/run" method="post">
  <div class="form-group">
      %for c in classifierList:
      <label class="checkbox-inline">
	<input type="checkbox" id="{{c}}" name="{{c}}" value="1"> {{c}}
      </label>
      %end
  </div>
  <div class="form-group">
    <button type="submit" class="btn btn-primary">Run classifiers</button>
  </div>
</form>

% include('footer.tpl')
