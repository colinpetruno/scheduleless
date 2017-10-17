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

      var START_HOURS = [6, 7, 8, 9, 10]
      var END_HOURS   = [16, 17, 18, 19, 20]

      var selectedStartMinutes = null,
          selectedEndMinutes = null;

      if (!$start.length || !$end.length) {
        return;
      }

      var collection,
          preference,
          shift;
      try {
        collection = JSON.parse($($start).attr('collection'))
        preference = JSON.parse($($start).attr('preference'))
      } catch (e) {
        console.log("Error Parsing JSON", e)
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
        $start.typeahead('val', timeString);
      }

      if (endVal) {
        var timeString = minuteToStringInCollection(collection_strings, endVal)
        $end.typeahead('val', timeString);
      }

      $start.on('typeahead:selected', function($e, datum) {
        selectedStartMinutes = datum.id
        $end.typeahead('destroy')
        endPicker = applyTypehead($end, endSourceDefaults)
        $(that).find('.start').val(datum.id)
      })

      $end.on('typeahead:selected', function($e, datum) {
        selectedEndMinutes = datum.id
        $start.typeahead('destroy')
        startPicker = applyTypehead($start, startSourceDefaults)
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

      function getDefaultHours (arr) {
        return arr.map(function (d) {
          return createTime(d)
        })
      }

      function getStartHours () {
        return START_HOURS
      }

      function getEndHours () {
        var arr = END_HOURS
        if (selectedStartMinutes !== null) {

          var startHour = selectedStartMinutes/60
          var lowerBound = startHour + preference.minimum_shift_length/60
          var upperBound = startHour + preference.maximum_shift_length/60

          var hours = [];
          for (var i = lowerBound; i <= upperBound; i++) {
            hours.push(i % 24);
          }

          arr = hours
        }
        return arr
      }

      function startSourceDefaults(q, sync) {
        var timeOverrides = getDefaultHours(getStartHours())
        if (q === '') {
          sync(bloodhound.get(timeOverrides));
        }

        else {
          bloodhound.search(q, sync);
        }
      }

      function endSourceDefaults(q, sync) {
        var timeOverrides = getDefaultHours(getEndHours())
        if (q === '') {
          sync(bloodhound.get(timeOverrides));
        }

        else {
          bloodhound.search(q, sync);
        }
      }

      function createTime (hour) {
        var suffix = 'am'

        if (hour >= 12) {
          suffix = 'pm'
          hour = hour % 12
        }

        if (hour == 0) {
          hour = 12
        }

        return hour + ':00 ' + suffix
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
        }).bind('change blur', function () {
          // custom function for check existing value in listing
          match = false
          for (var prop in bloodhound.index.datums) {
            if ($(this).val() == bloodhound.index.datums[prop].name) {
              match = true;
            }
          }

          if (!match) {
            $(this).val('');
          }
        });
      }

    })
  }

  window.Scheduleless.instantiateTimePickerRange();
})
