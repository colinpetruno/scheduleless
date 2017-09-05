$(document).on("turbolinks:load", function() {
  window.Scheduleless.instantiateTimePickers = function() {
    $("input.timepicker").each(function(e) {
      var that = this;

      var collection
      try {
        collection = JSON.parse($(this).attr('collection'))
      } catch (e) {
        console.warn("Could not parse", e);
        return;
      }

      var collection_strings = collection.map(function (d) {
        return {id: d[1], name: d[0].trim()}
      })

      function sort (a, b) {
        var date1 = new Date("1970-01-01 " + a.name),
            date2 = new Date("1970-01-01 " + b.name)

        if (date1 < date2) {
          return -1;
        } else if (date1 > date2) {
          return 1;
        }

        return 0;
      }

      var bloodhound = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        local: collection_strings,
        identify: function(obj) { return obj.name; },
        sorter: sort
      });

      function sourceDefaults(q, sync) {
        if (q === '') {
          sync(bloodhound.get('4:00 pm', '5:00 pm', '6:00 pm', '7:00 pm'));
        }

        else {
          bloodhound.search(q, sync);
        }
      }

      $(this).typeahead({
        hint: true,
        highlight: true,
        minLength: 0,
        classNames: {
          menu: 'tt-menu scrollable'
        }
      },
      {
        name: 'time_strings',
        display: 'name',
        limit: 24,
        source: sourceDefaults
      });
    })
  }

  window.Scheduleless.instantiateTimePickers();
})
