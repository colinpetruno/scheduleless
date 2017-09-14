$(document).on("turbolinks:load", function() {
  var scheduleless = window.Scheduleless;

  scheduleless.reinstantiatePickers = function() {
    scheduleless.instantiateDatePickers();
    scheduleless.instantiateDateRangePickers();
    scheduleless.instantiateTimePickers();
    scheduleless.instantiateTimePickerRange();
  };
});
