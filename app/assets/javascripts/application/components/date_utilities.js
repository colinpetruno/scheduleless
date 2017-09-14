window.Scheduleless.dateUtils = {
  toInteger: function(date) {
    var year = date.getFullYear().toString();
    var month = date.getMonth().toString();
    var day = date.getDate().toString();

    return year + month.padStart(2, "0") + day.padStart(2, "0");
  },

  datePickerFormat: function(date) {
    var weekdaysShort = window.Scheduleless.i18n.dates.weekdaysShort;
    var month = date.getMonth().toString();
    var day = date.getDate().toString();

    return weekdaysShort[date.getDay()] + " " + month + "/" + day;
  }
};
