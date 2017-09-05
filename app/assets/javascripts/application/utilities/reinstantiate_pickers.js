$(document).on("turbolinks:load", function() {
  var scheduleless = window.Scheduleless;

  scheduleless.reinstantiatePickers = function() {
    scheduleless.instantiateDatePickers();
    Scheduleless.instantiateTimePickers();
    Scheduleless.instantiateTimePickerRange();
  };
});
