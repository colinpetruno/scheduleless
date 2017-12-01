window.Scheduleless.dateUtils = {
  toInteger: function(date) {
    var year = date.getFullYear().toString();
    var month = (date.getMonth() + 1).toString();
    var day = date.getDate().toString();

    return year + month.padStart(2, "0") + day.padStart(2, "0");
  },

  datePickerFormat: function(date) {
    var weekdaysShort = window.Scheduleless.i18n.dates.weekdaysShort;
    var month = (date.getMonth() + 1).toString();
    var day = date.getDate().toString();

    // Mon 9/16
    return weekdaysShort[date.getDay()] + " " + month + "/" + day;
  },

  datePickerLongFormat: function(date) {
    var monthsShort = window.Scheduleless.i18n.dates.monthsShort;
    var weekdaysShort = window.Scheduleless.i18n.dates.weekdaysShort;

    var year = date.getFullYear().toString();
    var month = date.getMonth();
    var day = date.getDate().toString();

    // Sept 16, 2017
    return weekdaysShort[date.getDay()] + ", " + monthsShort[month] + " " + day + " " + year;
  }
};
