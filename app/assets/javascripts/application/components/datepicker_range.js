$(document).on("turbolinks:load", function() {
  var scheduleless = window.Scheduleless;

  scheduleless.instantiateDateRangePickers = function() {
    $.each(scheduleless.range_pickers, function(index, value) {
      value.destroy();
    });
    scheduleless.range_pickers = [];

    $(".datepicker_range").each(function() {

      var startDate;
      var endDate;
      var updateStartDate = function() {
        startPicker.setStartRange(startDate);
        endPicker.setStartRange(startDate);
        endPicker.setMinDate(startDate);
      };
      var updateEndDate = function() {
        startPicker.setEndRange(endDate);
        startPicker.setMaxDate(endDate);
        endPicker.setEndRange(endDate);
      };

      var $container = $(this);
      var $start = $(this).find(".datepicker-range-start");
      var $end = $(this).find(".datepicker-range-end");

      var startOptions = Object.assign({}, scheduleless.picker_options($start), {
        onSelect: function() {
          startDate = this.getDate();
          updateStartDate();

          return startDate;
        }
      });
      var startPicker = new Pikaday(startOptions);

      var endOptions = Object.assign({}, scheduleless.picker_options($end), {
        onSelect: function() {
          endDate = this.getDate();
          updateEndDate();

          return endDate;
        }
      });
      var endPicker = new Pikaday(endOptions);

      _startDate = startPicker.getDate(),
      _endDate = endPicker.getDate();

      if (_startDate) {
          startDate = _startDate;
          updateStartDate();
      }

      if (_endDate) {
          endDate = _endDate;
          updateEndDate();
      }

      window.Scheduleless.range_pickers.push(startPicker);
      window.Scheduleless.range_pickers.push(endPicker);
    });
  }

  scheduleless.instantiateDateRangePickers();
});
