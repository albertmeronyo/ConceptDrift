      </div>

    </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="//code.jquery.com/jquery.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="/js/bootstrap.min.js"></script>
    <script type="text/javascript">
      function makesure(action) {
        if (confirm('Are you sure?')) {
	  window.location.href = '/harmonize/' + action
        } else {
        return false;
        }
      }
    </script>

  </body>
</html>
