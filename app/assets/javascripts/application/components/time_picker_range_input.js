$(document).on("turbolinks:load", function() {
  var scheduleless = window.Scheduleless;

  window.Scheduleless.instantiateTimePickerRange = function() {
    scheduleless.time_range_pickers = [];

    function minuteToStringInCollection(collection, minute) {
      for (var index in collection) {
        var item = collection[index]
        if (item.id == minute) {
          return item.name
        }
      }
    }

    $(".time_picker_range").each(function(e) {
      var that = this;
      var $start = $(this).find(".timepicker-range-start");
      var $end = $(this).find(".timepicker-range-end");

      var startVal = $(that).find('.start').val()
      var endVal = $(that).find('.end').val()

      if (!$start.length || !$end.length) {
        return;
      }

      var collection
      try {
        collection = JSON.parse($($start).attr('collection'))
      } catch (e) {
        console.warn("Could not parse", e);
        return;
      }

      var collection_strings = collection.map(function (d) {
        return {id: d[1], name: d[0].trim()}
      })

      var bloodhound = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        local: collection_strings,
        identify: function(obj) { return obj.name; },
        sorter: sort
      });

      startPicker = applyTypehead($start, startSourceDefaults)
      endPicker = applyTypehead($end, endSourceDefaults)

      if (startVal) {
        var timeString = minuteToStringInCollection(collection_strings, startVal)
        $start.val(timeString)
      }

      if (endVal) {
        var timeString = minuteToStringInCollection(collection_strings, endVal)
        $end.val(timeString)
      }

      $start.on('typeahead:selected', function($e, datum) {
        $(that).find('.start').val(datum.id)
      })

      $end.on('typeahead:selected', function($e, datum) {
        $(that).find('.end').val(datum.id)
      })

      window.Scheduleless.time_range_pickers.push(startPicker);
      window.Scheduleless.time_range_pickers.push(endPicker);

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

      function startSourceDefaults(q, sync) {
        if (q === '') {
          sync(bloodhound.get('5:00 am', '6:00 am', '7:00 am', '8:00 am', '9:00 am'));
        }

        else {
          bloodhound.search(q, sync);
        }
      }

      function endSourceDefaults(q, sync) {
        if (q === '') {
          sync(bloodhound.get('4:00 pm', '5:00 pm', '6:00 pm', '7:00 pm'));
        }

        else {
          bloodhound.search(q, sync);
        }
      }

      function applyTypehead(selector, source) {
        selector.typeahead({
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
          source: source
        });
      }
    })
  }

  window.Scheduleless.instantiateTimePickerRange();
})
